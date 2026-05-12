import { appendToSheet } from '../lib/google-sheets';
import { payloadToRows, type SubmitPayload } from '../../src/lib/rsvp';

interface Env {
  GOOGLE_SERVICE_ACCOUNT_EMAIL?: string;
  GOOGLE_PRIVATE_KEY?: string;
  GOOGLE_SHEET_ID?: string;
}

function sanitize(str: string): string {
  return str.trim().replace(/<[^>]*>/g, '').slice(0, 500);
}

function jsonResponse(data: Record<string, unknown>, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Cache-Control': 'no-store',
    },
  });
}

function isSubmitPayload(body: unknown): body is SubmitPayload {
  if (!body || typeof body !== 'object') return false;
  const b = body as Record<string, unknown>;
  if (typeof b.householdId !== 'string' || !b.householdId) return false;
  if (typeof b.householdName !== 'string') return false;
  if (!Array.isArray(b.members) || b.members.length === 0) return false;
  return b.members.every((m) => {
    if (!m || typeof m !== 'object') return false;
    const mm = m as Record<string, unknown>;
    return (
      typeof mm.memberId === 'string' &&
      typeof mm.name === 'string' &&
      (mm.attending === 'yes' || mm.attending === 'no') &&
      (mm.attending === 'no' || typeof mm.meal === 'string')
    );
  });
}

export const onRequestPost: PagesFunction<Env> = async (context) => {
  try {
    const body = (await context.request.json()) as unknown;

    if (!isSubmitPayload(body)) {
      return jsonResponse({ success: false, message: 'Missing or invalid RSVP fields.' }, 400);
    }

    const sanitized: SubmitPayload = {
      householdId: sanitize(body.householdId),
      householdName: sanitize(body.householdName),
      members: body.members.map((m) => ({
        memberId: sanitize(m.memberId),
        name: sanitize(m.name),
        attending: m.attending,
        ...(m.attending === 'yes' && m.meal ? { meal: sanitize(m.meal) } : {}),
      })),
      dietaryNeeds: body.dietaryNeeds ? sanitize(body.dietaryNeeds) : undefined,
      note: body.note ? sanitize(body.note) : undefined,
    };

    const rows = payloadToRows(sanitized, new Date().toISOString());
    await appendToSheet(rows, context.env);

    const yes = sanitized.members.filter((m) => m.attending === 'yes').length;
    const no = sanitized.members.filter((m) => m.attending === 'no').length;
    let message: string;
    if (yes > 0 && no === 0) {
      message = "RSVP received! We can't wait to celebrate with you.";
    } else if (yes > 0 && no > 0) {
      message = `Got it — ${yes} attending, ${no} can't make it. Thanks for letting us know.`;
    } else {
      message = "We'll miss you! Thanks for letting us know.";
    }

    return jsonResponse({ success: true, message });
  } catch (err) {
    console.error('RSVP error:', err);
    return jsonResponse({ success: false, message: 'Something went wrong. Please try again or email us.' }, 500);
  }
};
