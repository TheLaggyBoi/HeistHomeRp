$(".character-box").hover(
    function() {
        $(this).css({
            "background": "rgb(21, 28, 34)",
            "transition": "500ms",
        });
    }, function() {
        $(this).css({
            "background": "rgb(21, 28, 34)",
            "transition": "500ms",
        });
    }
);

$(".character-box").click(function () {
    $(".character-box").removeClass('active-char');
    $(this).addClass('active-char');
    $(".character-buttons").css({"display":"block"});
    if ($(this).attr("data-ischar") === "true") {
        $("#delete").css({"display":"block"});
    } else {
        $("#delete").css({"display":"block"});
    }
});

$("#play-char").click(function () {
    $.post("http://esx_kashacters/CharacterChosen", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
        ischar: $('.active-char').attr("data-ischar"),
    }));
    Kashacter.CloseUI();
});

$("#deletechar").click(function () {
    $.post("http://esx_kashacters/DeleteCharacter", JSON.stringify({
        charid: $('.active-char').attr("data-charid"),
    }));
    Kashacter.CloseUI();
});

(() => {
    Kashacter = {};

    Kashacter.ShowUI = function(data) {
        $('.main-container').css({"display":"block"});
        if(data.characters !== null) {
            $.each(data.characters, function (index, char) {
                if (char.charid !== 0) {
                    var charid = char.identifier.charAt(4);
                    $('[data-charid=' + charid + ']').html('<h3 class="character-fullname">'+ char.firstname +' '+ char.lastname +'</h3><hr class="character-hr"><div class="character-info"><p class="character-info-work"><strong>Arbete: </strong><span>'+ char.job + ' - ' + char.job_grade + '</span></p><p class="character-info-money"><strong>Kontanter: </strong><span>'+ char.money +'</span></p><p class="character-info-bank"><strong>Bankkonto: </strong><span>'+ char.bank +'</span></p><br><p class="character-info-dateofbirth"><strong>Personnummer: </strong><span>'+ char.dateofbirth + ' - ' + char.lastdigits + '</span></p> <p class="character-info-gender"><strong>Könsidentitet: </strong><span>'+ char.sex +'</span></p><p class="character-info-gender"><strong>Telefon Nummer: </strong><span>'+ char.phone_number +'</span></p><p class="character-info-gender"><strong>Längd: </strong><span>'+ char.height +'</span></p></div>').attr("data-ischar", "true");
                }
            });
        }
    };

    Kashacter.CloseUI = function() {
        $('.main-container').css({"display":"none"});
        $(".character-box").removeClass('active-char');
        $("#delete").css({"display":"none"});
		$(".character-box").html('<h3 class="character-fullname"><hr class="character-hr"></h3><div class="character-info"><p class="character-info-new">Skapa en ny karaktär</p></div>').attr("data-ischar", "false");
    };
    window.onload = function(e) {
        window.addEventListener('message', function(event) {
            switch(event.data.action) {
                case 'openui':
                    Kashacter.ShowUI(event.data);
                    break;
            }
        })
    }

})();