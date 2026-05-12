/**
 * Pure helpers for the group RSVP flow.
 *
 * The form state is one row per invited member with a yes/no toggle and a
 * conditional meal choice. The submission payload always contains every
 * invited member, so the Google Sheet ends up with a row per invited person
 * (yes or no) — no silent drop-offs.
 */

export interface Member {
  id: string;
  name: string;
}

export interface Household {
  id: string;
  displayName: string;
  members: Member[];
}

export type Attendance = 'yes' | 'no' | null;

export interface MemberFormState {
  memberId: string;
  name: string;
  attending: Attendance;
  meal: string;
}

export function initFormState(household: Household): MemberFormState[] {
  return household.members.map((m) => ({
    memberId: m.id,
    name: m.name,
    attending: null,
    meal: '',
  }));
}

export function setAttendance(
  state: MemberFormState[],
  memberId: string,
  attending: Attendance,
): MemberFormState[] {
  return state.map((m) =>
    m.memberId === memberId
      ? { ...m, attending, meal: attending === 'yes' ? m.meal : '' }
      : m,
  );
}

export function setMeal(
  state: MemberFormState[],
  memberId: string,
  meal: string,
): MemberFormState[] {
  return state.map((m) => (m.memberId === memberId ? { ...m, meal } : m));
}

export interface FormValidation {
  ok: boolean;
  reasons: string[];
}

export function validate(state: MemberFormState[]): FormValidation {
  const reasons: string[] = [];
  for (const m of state) {
    if (m.attending === null) {
      reasons.push(`Mark whether ${m.name} is attending.`);
      continue;
    }
    if (m.attending === 'yes' && !m.meal) {
      reasons.push(`Choose a meal for ${m.name}.`);
    }
  }
  return { ok: reasons.length === 0, reasons };
}

export function attendingCount(state: MemberFormState[]): number {
  return state.filter((m) => m.attending === 'yes').length;
}

export function decliningCount(state: MemberFormState[]): number {
  return state.filter((m) => m.attending === 'no').length;
}

export interface SubmitMember {
  memberId: string;
  name: string;
  attending: 'yes' | 'no';
  meal?: string;
}

export interface SubmitPayload {
  householdId: string;
  householdName: string;
  members: SubmitMember[];
  dietaryNeeds?: string;
  note?: string;
}

export function toSubmitPayload(
  household: Household,
  state: MemberFormState[],
  extras: { dietaryNeeds?: string; note?: string } = {},
): SubmitPayload {
  return {
    householdId: household.id,
    householdName: household.displayName,
    members: state.map((m) => ({
      memberId: m.memberId,
      name: m.name,
      attending: m.attending === 'yes' ? 'yes' : 'no',
      ...(m.attending === 'yes' && m.meal ? { meal: m.meal } : {}),
    })),
    dietaryNeeds: extras.dietaryNeeds,
    note: extras.note,
  };
}

export interface SheetRowRecord {
  guestId: string;
  guestName: string;
  attending: boolean;
  memberName: string;
  mealChoice: string;
  dietaryNeeds: string;
  note: string;
  submittedAt: string;
}

export function payloadToRows(
  payload: SubmitPayload,
  submittedAt: string,
): SheetRowRecord[] {
  return payload.members.map((m) => ({
    guestId: payload.householdId,
    guestName: payload.householdName,
    attending: m.attending === 'yes',
    memberName: m.name,
    mealChoice: m.meal ?? '',
    dietaryNeeds: payload.dietaryNeeds ?? '',
    note: payload.note ?? '',
    submittedAt,
  }));
}

export interface HouseholdMatch {
  household: Household;
  matchedOn: string;
}

/**
 * Searches households by display name AND by individual member name, so a
 * guest can find their party by typing any name on the invitation.
 * Dedupes by household id, preferring the longest matched substring.
 */
export function findHouseholds(
  households: Household[],
  query: string,
): HouseholdMatch[] {
  const q = query.toLowerCase().trim();
  if (q.length < 2) return [];

  const matches = new Map<string, HouseholdMatch>();
  const consider = (h: Household, candidate: string) => {
    if (!candidate.toLowerCase().includes(q)) return;
    const existing = matches.get(h.id);
    if (!existing || candidate.length < existing.matchedOn.length) {
      matches.set(h.id, { household: h, matchedOn: candidate });
    }
  };

  for (const h of households) {
    consider(h, h.displayName);
    for (const m of h.members) {
      consider(h, m.name);
    }
  }

  return [...matches.values()];
}
