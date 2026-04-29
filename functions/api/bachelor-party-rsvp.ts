import { appendValuesToSheet } from '../lib/google-sheets';

interface BachelorRsvpBody {
  name: string;
  email: string;
  attending: boolean;
  nights?: string[];
  arrival?: string;
  departure?: string;
  transportation?: string;
  transportationOther?: string;
  transportNotes?: string;
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
    const body = await context.request.json() as BachelorRsvpBody;

    if (!body.name || typeof body.attending !== 'boolean') {
      return jsonResponse({ success: false, message: 'Missing required fields.' }, 400);
    }

    const now = new Date().toISOString();
    const name = sanitize(body.name);
    const email = body.email ? sanitize(body.email) : '';
    const nights = Array.isArray(body.nights) ? body.nights.map(sanitize).join(', ') : '';
    const arrival = body.arrival ? sanitize(body.arrival) : '';
    const departure = body.departure ? sanitize(body.departure) : '';
    const transportationRaw = body.transportation ? sanitize(body.transportation) : '';
    const transportationOther = body.transportationOther ? sanitize(body.transportationOther) : '';
    const transportation = transportationRaw === 'other' && transportationOther
      ? `other: ${transportationOther}`
      : transportationRaw;
    const transportNotes = body.transportNotes ? sanitize(body.transportNotes) : '';
    const dietaryNeeds = body.dietaryNeeds ? sanitize(body.dietaryNeeds) : '';
    const note = body.note ? sanitize(body.note) : '';

    const row = [
      name,
      email,
      body.attending ? 'Yes' : 'No',
      nights,
      arrival,
      departure,
      transportation,
      transportNotes,
      dietaryNeeds,
      note,
      now,
    ];

    await appendValuesToSheet([row], 'BachelorParty', context.env);

    return jsonResponse({
      success: true,
      message: body.attending
        ? "You're in. We'll be in touch with more details."
        : "No worries, thanks for letting us know.",
    });
  } catch (err) {
    console.error('Bachelor party RSVP error:', err);
    return jsonResponse({ success: false, message: 'Something went wrong. Please try again or text Brendan directly.' }, 500);
  }
};
