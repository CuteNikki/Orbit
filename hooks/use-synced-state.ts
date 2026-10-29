'use client';

import { useState } from 'react';

// Local state seeded from a prop (usually server data) that can be edited
// optimistically, and starts over from the prop whenever a new one arrives,
// e.g. after router.refresh(). The reset happens while rendering, so there's
// no extra render with the stale value as with syncing from an effect.
export function useSyncedState<T>(value: T) {
  const [state, setState] = useState(value);
  const [prevValue, setPrevValue] = useState(value);
  if (value !== prevValue) {
    setPrevValue(value);
    setState(value);
  }
  return [state, setState] as const;
}
