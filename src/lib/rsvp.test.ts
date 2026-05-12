import { describe, expect, it } from 'vitest';
import {
  attendingCount,
  decliningCount,
  findHouseholds,
  initFormState,
  payloadToRows,
  setAttendance,
  setMeal,
  toSubmitPayload,
  validate,
  type Household,
} from './rsvp';

const johnson: Household = {
  id: 'johnson-family',
  displayName: 'The Johnson Family',
  members: [
    { id: 'johnson-mark', name: 'Mark Johnson' },
    { id: 'johnson-emily', name: 'Emily Johnson' },
    { id: 'johnson-ava', name: 'Ava Johnson' },
    { id: 'johnson-ben', name: 'Ben Johnson' },
  ],
};

const solo: Household = {
  id: 'garcia-maria',
  displayName: 'Maria Garcia',
  members: [{ id: 'garcia-maria', name: 'Maria Garcia' }],
};

describe('initFormState', () => {
  it('creates one row per member with no attendance set', () => {
    const state = initFormState(johnson);
    expect(state).toHaveLength(4);
    expect(state.every((m) => m.attending === null && m.meal === '')).toBe(true);
  });
});

describe('setAttendance / setMeal', () => {
  it('updates only the targeted member and clears meal when declining', () => {
    let s = initFormState(johnson);
    s = setAttendance(s, 'johnson-mark', 'yes');
    s = setMeal(s, 'johnson-mark', 'filet');
    expect(s.find((m) => m.memberId === 'johnson-mark')?.meal).toBe('filet');

    s = setAttendance(s, 'johnson-mark', 'no');
    expect(s.find((m) => m.memberId === 'johnson-mark')?.meal).toBe('');
    expect(s.find((m) => m.memberId === 'johnson-emily')?.attending).toBe(null);
  });
});

describe('validate', () => {
  it('flags unanswered members and missing meals', () => {
    const s = initFormState(johnson);
    const v = validate(s);
    expect(v.ok).toBe(false);
    expect(v.reasons).toHaveLength(4);
  });

  it('passes when every member is answered and yes-members have meals', () => {
    let s = initFormState(johnson);
    s = setAttendance(s, 'johnson-mark', 'yes');
    s = setMeal(s, 'johnson-mark', 'filet');
    s = setAttendance(s, 'johnson-emily', 'yes');
    s = setMeal(s, 'johnson-emily', 'salmon');
    s = setAttendance(s, 'johnson-ava', 'no');
    s = setAttendance(s, 'johnson-ben', 'no');
    expect(validate(s).ok).toBe(true);
    expect(attendingCount(s)).toBe(2);
    expect(decliningCount(s)).toBe(2);
  });

  it('flags a yes-member without a meal', () => {
    let s = initFormState(solo);
    s = setAttendance(s, 'garcia-maria', 'yes');
    const v = validate(s);
    expect(v.ok).toBe(false);
    expect(v.reasons[0]).toMatch(/meal/i);
  });
});

describe('toSubmitPayload + payloadToRows', () => {
  it('writes one row per invited member, regardless of attendance', () => {
    let s = initFormState(johnson);
    s = setAttendance(s, 'johnson-mark', 'yes');
    s = setMeal(s, 'johnson-mark', 'filet');
    s = setAttendance(s, 'johnson-emily', 'yes');
    s = setMeal(s, 'johnson-emily', 'salmon');
    s = setAttendance(s, 'johnson-ava', 'no');
    s = setAttendance(s, 'johnson-ben', 'no');

    const payload = toSubmitPayload(johnson, s, {
      dietaryNeeds: 'nut allergy',
      note: 'see you soon',
    });
    expect(payload.members).toHaveLength(4);
    expect(payload.members.filter((m) => m.attending === 'yes')).toHaveLength(2);
    expect(payload.members.find((m) => m.memberId === 'johnson-ava')?.meal).toBeUndefined();

    const rows = payloadToRows(payload, '2026-05-01T12:00:00Z');
    expect(rows).toHaveLength(4);
    expect(rows.filter((r) => r.attending)).toHaveLength(2);
    expect(rows.every((r) => r.guestId === 'johnson-family')).toBe(true);
    expect(rows.every((r) => r.guestName === 'The Johnson Family')).toBe(true);
    expect(rows.every((r) => r.dietaryNeeds === 'nut allergy')).toBe(true);
    expect(rows.find((r) => r.memberName === 'Ava Johnson')?.mealChoice).toBe('');
  });

  it('handles a single-member household declining', () => {
    let s = initFormState(solo);
    s = setAttendance(s, 'garcia-maria', 'no');
    const rows = payloadToRows(toSubmitPayload(solo, s), '2026-05-01T12:00:00Z');
    expect(rows).toHaveLength(1);
    expect(rows[0]).toMatchObject({
      guestId: 'garcia-maria',
      memberName: 'Maria Garcia',
      attending: false,
      mealChoice: '',
    });
  });
});

describe('findHouseholds', () => {
  const households: Household[] = [johnson, solo];

  it('returns nothing for short queries', () => {
    expect(findHouseholds(households, 'a')).toEqual([]);
  });

  it('finds a household by member name', () => {
    const matches = findHouseholds(households, 'ava');
    expect(matches).toHaveLength(1);
    expect(matches[0].household.id).toBe('johnson-family');
  });

  it('finds a household by display name', () => {
    const matches = findHouseholds(households, 'johnson family');
    expect(matches).toHaveLength(1);
    expect(matches[0].household.id).toBe('johnson-family');
  });

  it('dedupes a household even when multiple members match', () => {
    const matches = findHouseholds(households, 'johnson');
    expect(matches).toHaveLength(1);
  });
});
