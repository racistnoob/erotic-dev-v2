// Collapsible.tsx

import React, { useState } from 'react';
import './Collapsible.css'; // Import the CSS file

interface CollapsibleProps {
  title: string;
  content: any;
}

const Collapsible: React.FC<CollapsibleProps> = ({ title, content }) => {
  const [isOpen, setIsOpen] = useState(false);

  const toggleCollapse = () => {
    const clickSound = document.getElementById('clickSound') as HTMLAudioElement;
    if (clickSound) {
        clickSound.currentTime = 0;
        clickSound.play();
    }
    setIsOpen(!isOpen);
  };

  return (
    <div>
      <button className={`collapsible${isOpen ? ' active' : ''}`} onClick={toggleCollapse}><h1>{title}</h1></button>
      <div className="content" style={{ maxHeight: isOpen ? '255em' : '0em' }}>
        {content}
      </div>
    </div>
  );
};

export default Collapsible;
