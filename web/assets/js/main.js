import { formatTime } from 'utils';

document.addEventListener('DOMContentLoaded', () => {
    const timeElement = document.getElementById('time');
    if (timeElement) {
        timeElement.textContent = formatTime(new Date());
        setInterval(() => {
            timeElement.textContent = formatTime(new Date());
        }, 1000);
    }
});
