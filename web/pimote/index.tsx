import React from 'react';
import { createRoot } from 'react-dom/client';

const PimoteRoot = () => <>hello from react!</>;

window.addEventListener('load', () => { 
    createRoot(document.getElementById('app-container')!).render(<PimoteRoot />);
});

