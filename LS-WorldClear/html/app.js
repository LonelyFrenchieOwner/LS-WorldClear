let countdownInterval = null;

window.addEventListener('message', (evt) => {
  if (evt.data.action !== 'start') return;

  const ui = document.getElementById('worldclear-ui');
  const timer = document.getElementById('wc-timer');
  const title = document.getElementById('wc-title');

  clearInterval(countdownInterval);
  let t = evt.data.time;

  title.textContent = evt.data.title || "SERVER WIDE WORLD CLEAR";
  timer.textContent = `${t} seconds left`;

  ui.classList.remove('hidden');
  ui.classList.add('visible');

  countdownInterval = setInterval(() => {
    t--;
    if (t > 0) {
      timer.textContent = `${t} seconds left`;
    } else {
      clearInterval(countdownInterval);
      timer.textContent = `DONE!`;

      setTimeout(() => {
        ui.classList.remove('visible');
        ui.classList.add('hidden');
      }, 2500);
    }
  }, 1000);
});

window.addEventListener('message', (evt) => {
    if (evt.data.action !== 'notify') return;
  
    const ui = document.getElementById('worldclear-ui');
    const title = document.getElementById('wc-title');
    const timer = document.getElementById('wc-timer');
  
    title.textContent = evt.data.title || "NOTICE";
    timer.textContent = "";
  
    ui.classList.add('compact');
    title.classList.add('compact');
  
    ui.classList.remove('hidden');
    ui.classList.add('visible');
  
    setTimeout(() => {
      ui.classList.remove('visible');
      setTimeout(() => {
        ui.classList.add('hidden');
        ui.classList.remove('compact');
        title.classList.remove('compact');
      }, 300);
    }, 2500);
  });
  