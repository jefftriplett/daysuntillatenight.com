var latenight = new Date('09/27/2019 6:30 PM'),
    _yyyy = latenight.getFullYear()+'',
    _yy = latenight.getFullYear()-1999+'',
    _yearspan = _yyyy+'-'+_yy,
    _second = 1000,
    _minute = _second * 60,
    _hour = _minute * 60,
    _day = _hour * 24,
    timer,
    initialRemaining = getRemaining(new Date());

recalculateCountdown();

// Setup tweet button text
tweetText = initialRemaining.days+' days, '+initialRemaining.hours+' hours, '+initialRemaining.minutes+' minutes, '+initialRemaining.seconds+' seconds until Late Night in the Phog '+_yearspan+' DaysUntilLateNight.com';
document.getElementById('tweet-button').setAttribute('data-text', tweetText);

// Initialize Twitter button
!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src=p+'://platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document, 'script', 'twitter-wjs');

/**
 * Get remaining time
 * @param Date now
 * @return object
 */
function getRemaining(now) {
    var distance = latenight - now;

    return {
        isExpired: distance < 0,
        days: Math.floor(distance / _day),
        hours: Math.floor((distance % _day) / _hour),
        minutes: Math.floor((distance % _hour) / _minute),
        seconds: Math.floor((distance % _minute) / _second)
    };
}

/**
 * Recalculate countdown on recurring basis
 *
 * Fires the following events:
 *  - "tick" on <body> when time remains until Late Night
 *  - "expired" on <body> when Late Night has begun
 */
function recalculateCountdown() {
    var remaining = getRemaining(new Date()),
        eventName = 'tick';

    if (remaining.isExpired) {
        eventName = 'expired';
        clearInterval(timer);
    }

    var event = new CustomEvent(eventName, {
        detail: {
            remaining: remaining
        },
        bubbles: true,
        cancelable: true
    });
    document.getElementsByTagName("body")[0].dispatchEvent(event);
}

// Repopulate days left in title
document.addEventListener('tick', function(e) {
    document.getElementById('heading-days').innerText = e.detail.remaining.days;
});

// Repopulate countdown
document.addEventListener("tick", function(e) {
    var r = e.detail.remaining,
        html = '<div class="number">'+r.days+'</div> days<br><div class="number">'+r.hours+'</div> hours<br><div class="number">'+r.minutes+'</div> minutes<br><div class="number">'+r.seconds+'</div> seconds';

    document.getElementById('numbers').innerHTML = html;
}, false);

// Handle expired countdown
document.addEventListener("expired", function(e) {
    document.getElementById('countdown').innerHTML = 'Late Night has begun!';
}, false);

timer = setInterval(recalculateCountdown, 1000);
