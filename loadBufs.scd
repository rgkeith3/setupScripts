{ |folderPath, numChannels =1, separate_channels=false|
	s.waitForBoot {
			var sampleFolder, recurseFolder, readFiles;
	d = d ? ();
	sampleFolder = PathName(folderPath);
	d.put(sampleFolder.fileName.asSymbol, ());

	readFiles = {|files|
		var fileArray = [];
		files.do({|file|
			var buf;
			if (separate_channels) {
				buf = (l: Buffer.readChannel(s, file.fullPath, channels: [0]), r: Buffer.readChannel(s, file.fullPath, channels: [1]));
			} {
				buf = Buffer.readChannel(s, file.fullPath, channels: Array.series(numChannels));
			};
			fileArray = fileArray ++ [buf];
		});
		fileArray;
	};

	recurseFolder = {|entry, dictionary|
		entry.postln;
		if (entry.folders.size > 0) {
			var folder = ();
			entry.folders.do({|subFolder|
				recurseFolder.value(subFolder, folder);
			});
			dictionary.put(entry.folderName.asSymbol, folder);
		} {
			dictionary.put(entry.folderName.asSymbol, readFiles.value(entry.files));
		}
	};
	sampleFolder.entries.do({ |entry|
		recurseFolder.value(entry, d[sampleFolder.fileName.asSymbol])
	});
	};
}