import React from 'react';
import styles from './Modal.module.css';

const Modal = ({ children, onClose }) => {
  return (
    <div className={styles.overlay}>
      <div className={styles.modal}>
        <button onClick={onClose} className={styles.closeButton}>X</button>
        {children}
      </div>
    </div>
  );
};

export default Modal;
