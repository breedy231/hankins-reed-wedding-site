import { appendToSheet } from '../lib/google-sheets';

interface RsvpGuest {
  name: string;
  meal: string;
}

interface RsvpBody {
  guestId: string;
  guestName: string;
  attending: boolean;
  guests?: RsvpGuest[];
  dietaryNeeds?: string;
  note?: string;
}

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

export const onRequestPost: PagesFunction<Env> = async (context) => {
  try {
    const body = await context.request.json() as RsvpBody;

    // Validate required fields
    if (!body.guestId || typeof body.attending !== 'boolean') {
      return jsonResponse({ success: false, message: 'Missing required fields.' }, 400);
    }

    if (body.attending && (!Array.isArray(body.guests) || body.guests.length === 0)) {
      return jsonResponse({ success: false, message: 'Guest details required when attending.' }, 400);
    }

    const now = new Date().toISOString();
    const guestName = sanitize(body.guestName || body.guestId);
    const note = body.note ? sanitize(body.note) : '';
    const dietaryNeeds = body.dietaryNeeds ? sanitize(body.dietaryNeeds) : '';

    if (body.attending && body.guests) {
      const rows = body.guests.map((g) => ({
        guestId: body.guestId,
        guestName,
        attending: true,
        memberName: sanitize(g.name),
        mealChoice: sanitize(g.meal),
        dietaryNeeds,
        note,
        submittedAt: now,
      }));
      await appendToSheet(rows, context.env);
    } else {
      await appendToSheet([{
        guestId: body.guestId,
        guestName,
        attending: false,
        note,
        submittedAt: now,
      }], context.env);
    }

    return jsonResponse({ success: true, message: body.attending ? 'RSVP received! We can\'t wait to celebrate with you.' : 'We\'ll miss you! Thanks for letting us know.' });
  } catch (err) {
    console.error('RSVP error:', err);
    return jsonResponse({ success: false, message: 'Something went wrong. Please try again or email us.' }, 500);
  }
};
