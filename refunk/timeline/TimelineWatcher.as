﻿/** 
    Copyright (c) 2009 Refunk <http://www.refunk.com>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

package refunk.timeline {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	import refunk.timeline.TimelineEvent;

	public class TimelineWatcher extends EventDispatcher {

		private var _timeline:MovieClip;
		private var previousLabel:String;
		
		/*
		 * The TimelineWatcher class provides functionality to watch a timeline
		 *
		 * @param timeline		The timeline to be watched
		 *
		 * The TimelineEvent.LABEL_REACHED event notifies you that a certain label is reached
		 * The TimelineEvent.END_REACHED event notifies you that the end of a timeline has been reached
		 */
		public function TimelineWatcher(timeline:MovieClip) {
			super();
			_timeline = timeline;
			_timeline.addEventListener(Event.ENTER_FRAME, watch);
		}
		
		private function watch(e:Event):void {
			try {
				var cf:int = _timeline.currentFrame;
				var cl:String = _timeline.currentLabel;
				if (cl !== previousLabel) {
					dispatchEvent(new TimelineEvent(TimelineEvent.LABEL_REACHED, cf, cl));
				}
				if (cf == _timeline.totalFrames) {
					dispatchEvent(new TimelineEvent(TimelineEvent.END_REACHED, cf, cl));
				}
				previousLabel = cl;
			}
			catch(err:Error) {}
		}
		
		/*
		 * Dispose a TimelineWatcher instance
		 */
		public function dispose():void {
			try {
				_timeline.removeEventListener(Event.ENTER_FRAME, watch);
				_timeline = null;
			}
			catch(err:Error) {}
		}
		
	}
}

/**
 * @usage
 * 
 * Import the TimelineWatcher and TimelineEvent classes
 * 
<code>
import com.refunk.events.TimelineEvent;
import com.refunk.timeline.TimelineWatcher;
</code>
 * 
 * Instantiate a TimelineWatcher instance and listen for the TimelineEvent.LABEL_REACHED and/or TimelineEvent.END_REACHED events
 * Use the event object to retrieve the label and/or frame number of where the event occurred
 * 
<code>
var timelineWatcher:TimelineWatcher = new TimelineWatcher(myMc);
timelineWatcher.addEventListener(TimelineEvent.LABEL_REACHED, handleTimelineEvent);
timelineWatcher.addEventListener(TimelineEvent.END_REACHED, handleTimelineEvent);

private function handleTimelineEvent(e:TimelineEvent):void {
	switch (e.type) {
		case TimelineEvent.LABEL_REACHED:
			trace("label: " + e.currentLabel + " reached at frame: " +  e.currentFrame);
			break;
		case TimelineEvent.END_REACHED:
			trace("timeline end reached at frame: " + e.currentFrame);
			break;
	}
}
</code>
 * 
 * Remove listeners and TimelineWatcher instance when not needed anymore
 * 
<code>
timelineWatcher.removeEventListener(TimelineEvent.LABEL_REACHED, handleTimelineEvent);
timelineWatcher.removeEventListener(TimelineEvent.END_REACHED, handleTimelineEvent);
timelineWatcher.dispose();
timelineWatcher = null;
</code>
 */
 