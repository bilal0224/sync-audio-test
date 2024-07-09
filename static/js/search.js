$(function(){
	function search(query) {
		query = query.trim();
		if (query.length == 0 && filtered.length == allTracks.length) {
			$("div.track").hide();
			$("div.track.featured").show();
		} else if (query.length == 0) {
			var tracks = filtered.map(function(track){
				return track.id;
			});
			$("div.track").hide().filter(function(index,track) {
				return tracks.indexOf(track.id) > -1;
			}).show();
		} else {
			var fuse = new Fuse(filtered, {
				"keys":["artist","title"],
				"id":"id"
			});
			var tracks = fuse.search(query);
			$("div.track").hide().filter(function(index,track) {
				return tracks.indexOf(track.id) > -1;
			}).show();
		}
	}
	var genres = [];
	var moods = [];
	var styles = [];
	var tempos = [];
	var filtered = [];
	function filterTracks() {
		$("div.filters ul").hide();
		$("div.filterTabs ul li").removeClass("selected");
		var appliedFiltersDiv = $("div.appliedFilters");
		appliedFiltersDiv.empty();
		if (styles.length == 0 && genres.length == 0 && moods.length == 0 && tempos.length == 0) {
			filtered = allTracks;
		} else {
			function addAppliedFilters(array, type) {
				for (var i=0; i<array.length; i++) {
					var filterElementName = $('<span></span>').text(array[i]);
					var filterElement = $('<div class="filter '+type+'"></div>');
					var filterElementRemove = $('<a href="javascript:void(0)" data-type="'+type+'"></a>');
					filterElementRemove.html("&times;");
					filterElementRemove.on("click", function(){
						var toRemove = $(this).parent().find("span").text();
						var filterType = $(this).data("type");
						$("div.filters ul li input."+filterType).each(function(){
							if ($(this).val() == toRemove) {
								$(this).trigger("click");
								return;
							}
						});
					});
					filterElement.on("click", function(){
						$(this).find("a").trigger("click");
					});
					filterElement.append(filterElementName);
					filterElement.append(filterElementRemove);
					appliedFiltersDiv.append(filterElement);
				}
			}
			addAppliedFilters(genres, "genre");
			addAppliedFilters(moods, "mood");
			addAppliedFilters(styles, "style");
			addAppliedFilters(tempos, "tempo");
			filtered = allTracks.filter(function(track) {
				var included = styles.length == 0 || styles.indexOf(track.style) > -1;
				if (!included) {
					return false;
				}
				included = false;
				if (genres.length > 0) {
					for (var i=0; i<genres.length; i++) {
						if (track.genres.indexOf(genres[i]) > -1) {
							included = true;
							break;
						}
					}
				} else {
					included = true;
				}
				if (!included) {
					return false;
				}
				included = false;
				if (moods.length > 0) {
					for (var i=0; i<moods.length; i++) {
						if (track.moods.indexOf(moods[i]) > -1) {
							included = true;
							break;
						}
					}
				} else {
					included = true;
				}
				if (!included) {
					return false;
				}
				included = false;
				if (styles.length > 0) {
					for (var i=0; i<styles.length; i++) {
						if (track.style == styles[i]) {
							included = true;
							break;
						}
					}
				} else {
					included = true;
				}
				if (!included) {
					return false;
				}
				included = false;
				if (tempos.length > 0) {
					for (var i=0; i<tempos.length; i++) {
						var match = tempos[i].match(/(\d+)–(\d+) BPM/i);
						if (!match) {
							return false;
						}
						var min = parseInt(match[1]);
						var max = parseInt(match[2]);
						var trackTempo = parseInt(track.tempo);
						if (trackTempo >= min && trackTempo <= max) {
							included = true;
							break;
						}
					}
				} else {
					included = true;
				}
				return included;
			});
		}
		search(searchInput.val());
	}
	var allTracks = filtered = $("div.track").map(function(index,track){
		return {
			"id":$(track).attr("id"),
			"title":$(track).find("li.title").text(),
			"artist":$(track).find("li.artist").text(),
			"genres":$(track).data("genre").split(/, */),
			"moods":$(track).data("mood").split(/, */),
			"style":$(track).data("style"),
			"tempo":$(track).data("tempo")
		};
	}).get();
	var searchInput = $("div.search div.input input[type='text']");
	searchInput.on("keyup", function(){
		search(this.value);
	});
	function updateFilterCount() {
		var filterCount = $("div.filters input:checked").length;
		if ($("div.filters:visible").length == 0) {
			if (filterCount > 0) {
				$("a.filters").text("Show filters ("+filterCount+")");
			} else {
				$("a.filters").text("Show filters");
			}
		} else {
			$("a.filters").text("Hide filters");
		}
	}
	$("div.track ul li.artist a.artist").on("click", function(){
		var name = $(this).text();
		searchInput.val(name);
		searchByArtist(name);
		return false;
	});
	$("div.search a.clear").on("click", function(){
		searchInput.val("");
		search("");
	});
	$("div.filters input.genre").on("change", function(){
		genres = $("div.filters input.genre:checked").map(function(){
			return $(this).val();
		}).get();
		filterTracks();
		updateFilterCount();
		searchInput.focus();
	});
	$("div.filters input.mood").on("change", function(){
		moods = $("div.filters input.mood:checked").map(function(){
			return $(this).val();
		}).get();
		filterTracks();
		updateFilterCount();
		searchInput.focus();
	});
	$("div.filters input.style").on("change", function(){
		styles = $("div.filters input.style:checked").map(function(){
			return $(this).val();
		}).get();
		filterTracks();
		updateFilterCount();
		searchInput.focus();
	});
	$("div.filters input.tempo").on("change", function(){
		tempos = $("div.filters input.tempo:checked").map(function(){
			return $(this).val();
		}).get();
		filterTracks();
		updateFilterCount();
		searchInput.focus();
	});
	$("a.filters").on("click", function(){
		if ($("div.filters:visible").length > 0) {
			$("div.filters").hide();
		} else {
			$("div.filters").show();
		}
		updateFilterCount();
	});
	$("div.filterTabs ul li a").on("click", function(){
		$("div.filters ul").hide();
		$(this).parent().toggleClass("selected");
		if ($(this).parent().hasClass("selected")) {
			$("div.filters ul."+this.name).show();
		}
		$(this).closest("ul").find("li.selected").not($(this).parent()).removeClass("selected");
	});
});