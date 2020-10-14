window.addEventListener('message', function(event) {


    switch (event.data.action) {
        case 'tick':
            $(".container").css("display", event.data.show ? "none" : "block");
            $("#boxHeal").css("width", event.data.health + "%");
            $("#boxArmor").css("width", event.data.armor + "%");
            //$("#boxStamina").css("width", event.data.stamina + "%");
            widthHeightSplit(event.data.stamina, $("#boxStamina"));
            if (event.data.speed < 10) {
                $('.speed-val').html('00' + event.data.speed);
            } else if (event.data.speed < 100 && event.data.speed >= 10) {
                $('.speed-val').html('0' + event.data.speed);
            } else {
                $('.speed-val').html(event.data.speed);
            }

            $('.measurement-val').html(event.data.sign);

            if (event.data.speed >= 100) {
                $('.speed-val').addClass('fast');
            } else {
                $('.speed-val').removeClass('fast');
            }

            $('.clock').html(event.data.time + ' <span class="ampm">' + event.data.ampm + '</span>');

            if (event.data.street2 !== '') {
                $('.position').html(event.data.direction + ' <span class="seperator">|</span> ' + event.data.street1 + ' <span class="seperator2">-</span> ' + event.data.street2 + ' <span class="seperator">|</span> ' + event.data.area);
            } else {
                $('.position').html(event.data.direction + ' <span class="seperator">|</span> ' + event.data.street1 + ' <span class="seperator">|</span> ' + event.data.area);
            }
            break;

        case 'updateStatus':
            //$('#boxHunger').css('width', event.data.hunger + '%');
            widthHeightSplit(event.data.hunger, $("#boxHunger"));
            //$('#boxThirst').css('width', event.data.thirst + '%');
            widthHeightSplit(event.data.thirst, $("#boxThirst"));
            //$('#boxStress').css('width', event.data.stress + '%');
            widthHeightSplit(event.data.stress, $("#boxStress"));
            break;
        case 'showui':
            $('body').fadeIn();
            break;
        case 'hideui':
            $('body').fadeOut();
            break;
        case 'hidecar':
            $('.car').fadeOut();
            break;
        case 'showcar':
            $('.car').fadeIn();
            break;
        case 'showui':
            $('body').fadeIn();
            break;
        case 'hideui':
            $('body').fadeOut();
            break;
        case 'toggle-seatbelt':
            if ($('.seatbelt').hasClass('on')) {
                $('.seatbelt').addClass('off').removeClass('on');
            } else {
                $('.seatbelt').addClass('on').removeClass('off');
            }
            break;
        case 'set-seatbelt':
            if (!event.data.seatbelt) {
                $('.seatbelt').addClass('off').removeClass('on');
            } else {
                $('.seatbelt').addClass('on').removeClass('off');
            }
            break;
        case 'toggle-cruise':
            if ($('.cruise').hasClass('on')) {
                $('.cruise').addClass('off').removeClass('on');
            } else {
                $('.cruise').addClass('on').removeClass('off');
            }
            break;
        case 'set-cruise':
            if (!event.data.cruise) {
                $('.cruise').addClass('off').removeClass('on');
            } else {
                $('.cruise').addClass('on').removeClass('off');
            }
            break;
        case 'update-fuel':
            if (event.data.fuel < 100) {
                $('.fuel-val').html('0' + event.data.fuel);
            } else {
                $('.fuel-val').html(event.data.fuel);
            }

            if (event.data.fuel <= 10) {
                $('.fuel-val').addClass('low');
            } else {
                $('.fuel-val').removeClass('low');
            }

            break;
        case 'set-voice':
            $("#boxVoice").css("width", event.data.value + "%");
            break;
        case 'voice-color':
            if (event.data.isTalking) {
                $("#boxVoiceOn").css("width", "100%");
                $('#boxVoice').addClass('active');
                $("#boxVoice2On").css("width", "100%");
                $('#boxVoice2').addClass('active');
                $("#boxVoice3On").css("width", "100%");
                $('#boxVoice3').addClass('active');
            } else {
                $("#boxVoiceOn").css("width", "0%");
                $('#boxVoice').removeClass('active');
                $("#boxVoice2On").css("width", "0%");
                $('#boxVoice2').removeClass('active');
                $("#boxVoice3On").css("width", "0%");
                $('#boxVoice3').removeClass('active');
            }
            break;
    }
});

function formatCurrency(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function widthHeightSplit(value, ele) {
    let height = 20.0;
    let eleHeight = (value / 100) * height;
    let leftOverHeight = height - eleHeight;

    ele.css("height", eleHeight + "px");
    ele.css("left", leftOverHeight + "px");
};