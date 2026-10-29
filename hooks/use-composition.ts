'use client';

import type React from 'react';
import { useRef } from 'react';

// Tells whether a keydown belongs to an IME composition (Japanese, Chinese,
// Korean input…), so Enter can pick a word instead of submitting. Most browsers
// flag those keydowns with isComposing, but Safari fires the Enter that
// confirms the word just after compositionend, when it's already false; the
// Enter that follows compositionend is skipped as well. Spread `handlers` onto
// the input and check `isComposing(e)` first thing in its onKeyDown.
export function useComposition() {
  const composing = useRef(false);
  const justEnded = useRef(false);

  return {
    handlers: {
      onCompositionStart: () => {
        composing.current = true;
      },
      onCompositionEnd: () => {
        composing.current = false;
        justEnded.current = true;
        // The confirming keydown comes in the same turn of the event loop
        setTimeout(() => {
          justEnded.current = false;
        });
      },
    },
    isComposing: (e: React.KeyboardEvent) =>
      e.nativeEvent.isComposing || composing.current || justEnded.current,
  };
}
