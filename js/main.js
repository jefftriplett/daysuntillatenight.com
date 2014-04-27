var latenight = new Date('10/03/2014 6:30 PM'),
    _second = 1000,
    _minute = _second * 60,
    _hour = _minute * 60,
    _day = _hour * 24,
    timer;

document.getElementById('heading-days').innerText = Math.floor((latenight-new Date()) / _day);

function showNumbers() {
    var numbers = document.getElementById('numbers'),
        now = new Date(),
        distance = latenight - now;

    if (distance < 0) {
        clearInterval(timer);
        numbers.innerHTML = 'Get to the Fieldhouse!';

        return;
    }

    var tilLateNight = {
        days: Math.floor(distance / _day),
        hours: Math.floor((distance % _day) / _hour),
        minutes: Math.floor((distance % _hour) / _minute),
        seconds: Math.floor((distance % _minute) / _second)
    };

    numbers.innerHTML = '<div class="number">'+tilLateNight.days+'</div> days<br><div class="number">'+tilLateNight.hours+'</div> hours<br><div class="number">'+tilLateNight.minutes+'</div> minutes<br><div class="number">'+tilLateNight.seconds+'</div> seconds';
}

timer = setInterval(showNumbers, 1000);
