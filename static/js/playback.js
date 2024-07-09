(function(){
	var buttons = ["play","pause"];
	var srcSet = {};
	for (var i=0; i<buttons.length; i++) {
		var set = {
			"src": "/images/icon-"+buttons[i]+".png",
			"srcset": "/images/icon-"+buttons[i]+"@2x.png 2x, /images/icon-"+buttons[i]+"@3x.png 3x"
		}
		srcSet[buttons[i]] = set;
	}
	function formatDuration(trackDuration) {
		var durationMinutes = Math.floor(trackDuration / 60);
		var durationSeconds = Math.round(trackDuration % 60);
		return (durationMinutes+"").padStart(2, "0")+":"+(durationSeconds+"").padStart(2, "0");
	}
	$(function(){
		var audio = $("#player audio").get(0);
		var playButton = $("#player a.play");
		var fwdButton = $("#player a.fwd");
		var rwdButton = $("#player a.rwd");
		var stopButton = $("#player a.stop");
		var trackInfoTitle = $("#player div.info span.title");
		var trackInfoArtist = $("#player div.info span.artist");
		var trackInfoPlayed = $("#player div.info span.time span.played");
		var trackInfoRemaining = $("#player div.info span.time span.remaining");
		var transportPlayed = $("#player div.transport div.played");
		var isTouchDevice = 'ontouchstart' in document.documentElement;
		var audioPausedBeforeSeek = false;
		var transport;
		var seekStarted = false;
		var events = {
			"down":"mousedown",
			"up":"mouseup",
			"move":"mousemove"
		};
		if (isTouchDevice) {
			events.down = "touchstart";
			events.up = "touchend";
			events.move = "touchmove";
		}
		$(document).on(events.up, function(event){
			if (transport) {
				var x = (event.changedTouches ? event.changedTouches[0].pageX : event.pageX) - transport.offset().left;
				var percentPlayed = x / transport.innerWidth() * 100;
				setPercentPlayed(percentPlayed);
				audio.currentTime = audio.duration * percentPlayed / 100;
				if (!audioPausedBeforeSeek) {
					audio.play();
				}
				transport = null;
			}
		}).on(events.move, function(event){
			if (transport) {
				var x = (event.changedTouches ? event.changedTouches[0].pageX : event.pageX) - transport.offset().left;
				var percentPlayed = x / transport.innerWidth() * 100;
				setPercentPlayed(percentPlayed);
			}
		});
		$("#player div.transport, div.track div.waveform").on(events.down,function(event){
			if (!$(this).hasClass("waveform") || $(this).parents("div.track").attr("id") == currentTrackId) {
				audioPausedBeforeSeek = audio.paused;
				audio.pause();
				transport = $(this);
			}
		});
		var currentTrackId;
		audio.onplay = function() {
			playButton.find("img").attr(srcSet.pause);
			$("div.track a.play img").attr(srcSet.play);
			currentTrackId = $(audio).data("track_id");
			$("#"+currentTrackId+" a.play img").attr(srcSet.pause);
		}
		audio.onpause = function() {
			playButton.find("img").attr(srcSet.play);
			var trackId = $(audio).data("track_id");
			$("#"+trackId+" a.play img").attr(srcSet.play);
		}
		audio.ontimeupdate = function() {
			var percentPlayed = audio.currentTime / audio.duration * 100;
			trackInfoPlayed.text(formatDuration(audio.currentTime));
			setPercentPlayed(percentPlayed);
		}
		function setPercentPlayed(percentPlayed) {
			percentPlayed = Math.max(Math.min(percentPlayed, 100), 0);
			transportPlayed.css("width", percentPlayed+"%");
			$("#"+currentTrackId+" div.waveform div.played").css("width", percentPlayed+"%");
		}
		function playTrack(trackId) {
			if (currentTrackId && currentTrackId == trackId) {
				if (!audio.paused) {
					audio.pause();
				} else {
					audio.play();
				}
				return;
			}
			var checksum = $("#"+trackId).data("checksum");
			$("div.track div.waveform div.played").css("width", "0px");
			audio.src = "/tracks/"+checksum+".mp3";
			trackInfoTitle.text($("#"+trackId+" li.title").text());
			trackInfoArtist.text($("#"+trackId+" li.artist").text());
			var trackDuration = $("#"+trackId).data("duration");
			var duration = formatDuration(trackDuration);
			trackInfoRemaining.text(duration);
			$(audio).data("track_id", trackId);
			if (!audio.paused) {
				audio.pause();
			} else {
				$("#player").show();
				audio.play();
			}
		}
		playButton.on("click", function(){
			if (!audio.paused) {
				audio.pause();
			} else {
				audio.play();
			}
		});
		stopButton.on("click", function(){
			audio.pause();
			$("div.track div.waveform div.played").css("width", "0px");
			currentTrackId = null;
			$("#player").hide();
		});
		fwdButton.on("click", function(){
			var trackId = $(audio).data("track_id");
			if (trackId) {
				var nextTrackId = $("#"+trackId).next(":visible").attr("id");
				if (nextTrackId) {
					playTrack(nextTrackId);
				}
			}
		});
		rwdButton.on("click", function(){
			if (audio) {
				var trackId = $(audio).data("track_id");
				if (trackId && audio.currentTime > 1) {
					var previousTrackId = $("#"+trackId).prev(":visible").attr("id");
					if (previousTrackId) {
						playTrack(previousTrackId);
					}
				} else {
					audio.currentTime = 0;
				}
			}
		});
		$("div.track ul li a.play").on("click",function(){
			var trackId = $(this).parents("div.track").attr("id");
			playTrack(trackId);
			return false;
		});
	});
})();