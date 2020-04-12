/*
* Magic Mirror Config
*
* For more information how you can configurate this file
* See https://github.com/MichMich/MagicMirror#configuration
*
*/

var config = {
	address: "0.0.0.0", // Address to listen on, can be:
	// - "localhost", "127.0.0.1", "::1" to listen on loopback interface
	// - another specific IPv4/6 to listen on a specific interface
	// - "", "0.0.0.0", "::" to listen on any interface
	// Default, when address config is left out, is "localhost"
	port: 8080,
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.0.1/120", "192.168.0.1/24"],  // Set [] to allow all IP addresses
	// or add a specific IPv4 of 192.168.1.5 :
	// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
	// or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
	// ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],

	language: "fr",
	timeFormat: 24,
	units: "metric",
	customCss: "css/custom.css",

	modules: [
		// ***********************
		// ***********************
		// Excludes //////////////
		// ***********************
		// ***********************
		{
			module: "MMM-pages",
			config: {
				modules:
					[["worldclock", "weatherforecast", "MMM-MoonPhase", "compliments", "MMM-AlarmClock"],
						["calendar"],
						["MMM-LocalTransport", "MMM-SystemStats", "MMM-FreeBox-Monitor", "compliments", "MMM-NowPlayingOnSpotify"]],
				fixed: ["clock", "currentweather", "MMM-page-indicator", "newsfeed", "MMM-ModuleScheduler", "updatenotification", "alert"],
				rotationTime: 12000,
			}
		},
		{
			module: "alert",
		},
		{
			module: "MMM-Remote-Control"
			// uncomment the following line to show the URL of the remote control on the mirror
			// , position: 'bottom_left'
			// you can hide this module afterwards from the remote control itself
		},
		// /// /// /// /// /// ///
		// top_left
		// /// /// /// /// /// ///
		{
			module: "clock",
			position: "top_left",
			config: {
				timeFormat: 24,
				showWeek: true,
				timezone: "Europe/Paris",
			}
		},
		// /// /// /// /// /// ///
		// top_right
		// /// /// /// /// /// ///
		{
			module: "currentweather",
			position: "top_right",
			config: {
				location: "Paris",
				locationID: "1234567",  //ID from http://www.openweathermap.org/help/city_list.txt
				appid: "xyxyxyxyxyxyxyxyxyxyxy",
			}
		},
		// /// /// /// /// /// ///
		// bottom_bar
		// /// /// /// /// /// ///
		{
			module: "newsfeed",
			position: "bottom_bar",
			config: {
				feeds: [
					{
						title: "Le Monde",
						url: "https://www.lemonde.fr/rss/une.xml",
					},
					{
						title: "Le Figaro",
						url: "http://www.lefigaro.fr/rss/figaro_actualites.xml",
					},
				],
				showSourceTitle: true,
				showPublishDate: true,
			}
		},
		{
			module: "MMM-page-indicator",
			position: "bottom_bar",
			config: {
				pages: 3,
			}
		},
		{
			module: "updatenotification",
			position: "bottom_bar",
		},

		// ***********************
		// ***********************
		// Page 1 ////////////////
		// ***********************
		// ***********************

		// /// /// /// /// /// ///
		// top_left
		// /// /// /// /// /// ///
		{
			module: "worldclock",
			position: "top_left", // This can be any of the regions, best results in top_left or top_right regions
			config: {
				// See 'Configuration options' for more information.

				timeFormat: "HH:mm", //defined in moment.js format()
				style: "right", //predefined 4 styles; 'top', 'left','right','bottom'
				timeClass: "normal large thin",
				captionClass: "block-caption small bright light align-right",
				zoneElement: "div",
				zoneClass: "zone",
				gapElement: "div",
				gapClass: "dimmed",
				clocks: [
					{
						title: "Réunion", // Too long title could cause ugly text align.
						timezone: "Indian/Reunion", //When omitted, Localtime will be displayed. It might be not your purporse, I bet.
						//flag: 're'
					},
					{
						title: "Guadeloupe", // Too long title could cause ugly text align.
						timezone: "America/Guadeloupe", //When omitted, Localtime will be displayed. It might be not your purporse, I bet.
						//flag: 'gp'
					},
				]
			}
		},
		{
			module: "MMM-MoonPhase",
			position: "top_left",
			config: {
				updateInterval: 43200000,
				hemisphere: "N",
				resolution: "detailed",
				basicColor: "white",
				title: true,
				phase: true,
				x: 200,
				y: 200,
				alpha: 0.7
			}
		},
		// /// /// /// /// /// ///
		// top_right
		// /// /// /// /// /// ///
		{
			module: "weatherforecast",
			position: "top_right",
			header: "Weather Forecast",
			config: {
				tableClass: "medium",
				location: "Paris",
				locationID: "1234567",  //ID from http://www.openweathermap.org/help/city_list.txt
				appid: "xyxyxyxyxyxyxyxyxyxyxy",
			}
		},
		{
			module: "MMM-AlarmClock",
			position: "top_right",
			config: {
				format: "ddd, HH:mm",
				timer: 6000, // 6 seconds
				fade: false,
				fadeTimer: 0, // 0 seconds
				fadeStep: 1.0, // 100%
				alarms: [
					// 0 => Dimanche, 1 => Lundi, 2 => Mardi, 3 => Mercredi, 4 => Jeudi, 5 => Vendredi, 6 => Samedi
					// text to mp3 https://soundoftext.com/
					// Extinction des écrans à 17h la semaine
					{
						time: "17:00",
						days: [1, 2, 4, 5], // Lundi, mardi, jeudi et vendredi à 17h00
						title: "Extinction",
						message: "On éteint les écrans les enfants, s'il vous plaît.",
						sound: "extinction_ecran.mp3",
					},
					// Les enfants au lit après la télé
					{
						time: "21:00",
						days: [0, 1, 2, 3, 4, 5, 6], // Vendredi et samedi
						title: "Au lit",
						message: "Il est l'heure d'aller se coucher les enfants",
						sound: "clochette001.mp3",
						timer: 10100,
					},
				],
			}
		},
		// /// /// /// /// /// ///
		// lower_third
		// /// /// /// /// /// ///
		{
			module: "compliments",
			position: "lower_third",	// This can be any of the regions.
			// Best results in one of the middle regions like: lower_third
			config: {
				compliments: {
					anytime: [
						"Hey là sexy!",
					],
					morning: [
						"Bonjour beauté!",
						"Profite de ta journée!",
						"As-tu bien dormi?",
						"Sois meilleur que tu ne l'as été hier!",
						"Le but n'est pas d'être LE meilleur mais d'être meilleur qu'hier!",
						"Être meilleur qu'hier!",
						"Bonjour rayon de Soleil!",
						"Qui a besoin de café quand tu as ton sourire?",
					],
					afternoon: [
						"Hello, beauty!",
						"Tu as l'air superbe!",
						"Tu as l'air bien aujourd'hui!",
						"Tu fais la différence!",
					],
					evening: [
						"Wow, tu as l'air chaud!",
						"Tu as l'air sympa!",
						"Hi, sexy!",
						"Fais de beaux rêves cette nuit!",
						"Tu as fait sourire quelqu'un aujourd'hui, je le sais.",
						"La journée était meilleure grâce à tes efforts.",
					],
					day_sunny: [
						"Aujourd'hui est une journée ensoleillée",
						"C'est une belle journée!",
					],
					snow: [
						"Bataille de boules de neige!",
					],
					rain: [
						"N'oublie pas ton parapluie!",
					],
					thunderstorm: [
						"Il y a de l'orage dans l'air!",
					],
					fog: [
						"Une purée de pois!",
					]
				},
				classes: "thin large bright",
			}
		},

		// ***********************
		// ***********************
		// Page 2 ////////////////
		// ***********************
		// ***********************

		// /// /// /// /// /// ///
		// middle_center
		// /// /// /// /// /// ///
		{
			module: "calendar",
			header: "Corvée",
			position: "middle_center",
			config: {
				maxTitleLength: 50,
				colored: false,
				maximumEntries: 1,
				tableClass: "medium",
				calendars: [
					{
						symbol: "cutlery ", /* Corvée */
						url: "https://calendar.google.com/calendar/ical/xyxyxyxyxyxy/basic.ics",
						color: "#ffffff",
						titleClass: "medium",
						timeClass: "medium",
					},
				]
			}
		},
		{
			module: "calendar",
			header: "Agenda",
			position: "middle_center",
			config: {
				maxTitleLength: 50,
				colored: false,
				tableClass: "small",
				calendars: [
					{
						symbol: "adn ", /* Membre #1 */
						url: "https://calendar.google.com/calendar/ical/xyxyxyxyxyxy/basic.ics",
						color: "#4285F4",
						titleClass: "medium",
						timeClass: "small",
					},
					{
						symbol: "rocket ", /* Membre #2 */
						url: "https://calendar.google.com/calendar/ical/xyxyxyxyxyxy/basic.ics",
						color: "#E67C73",
						titleClass: "medium",
						timeClass: "small",
					},
					{
						symbol: "female ", /* Membre #3 */
						url: "https://calendar.google.com/calendar/ical/xyxyxyxyxyxy/basic.ics",
						color: "#795548",
						titleClass: "medium",
						timeClass: "small",
					},
					{
						symbol: "calendar ", /* Vacances Scolaires Zone C */
						url: "webcal://www.education.gouv.fr/download.php?file=//cache.media.education.gouv.fr/ics/Calendrier_Scolaire_Zone_C.ics",
						color: "#ffffff",
						titleClass: "medium",
						timeClass: "small",
					},
					{
						symbol: "calendar ", /* Jours fériés */
						url: "https://calendar.google.com/calendar/ical/fr.french%23holiday%40group.v.calendar.google.com/public/basic.ics",
						color: "#ffffff",
						titleClass: "medium",
						timeClass: "small",
					}
				]
			}
		},
		{
			module: "calendar",
			header: "Anniversaires",
			position: "middle_center",
			config: {
				maxTitleLength: 50,
				colored: false,
				maximumEntries: 5,
				tableClass: "small",
				calendars: [
					{
						symbol: "birthday-cake ", /* Anniversaire */
						url: "https://calendar.google.com/calendar/ical/borthday-xyxyxyxyxyxy/basic.ics",
						color: "#ffffff",
						titleClass: "small",
						timeClass: "small",
					},
				]
			}
		},

		// ***********************
		// ***********************
		// Page 3 ////////////////
		// ***********************
		// ***********************

		// /// /// /// /// /// ///
		// top_left
		// /// /// /// /// /// ///
		{
			module: "MMM-FreeBox-Monitor",
			position: "top_left",	// This can be any of the regions. Best results in left or right regions.
			config: {
				mirrorName: "Freebox",
				ip: "http://192.168.0.000",
				// See 'Configuration options' for more information.
				maxCallEntries: 3,
				displayMissedCalls: true,
				displayDownloads: false,
			}
		},
		// /// /// /// /// /// ///
		// top_right
		// /// /// /// /// /// ///
		{
			module: "MMM-SystemStats",
			position: "top_right", // This can be any of the regions.
			classes: "small dimmed", // Add your own styling. Optional.
			language: "fr",
			config: {
				updateInterval: 10000,
				animationSpeed: 0,
				align: "right", // align labels
				//header: 'System Stats', // This is optional
			},
		},
	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {
	module.exports = config;
}