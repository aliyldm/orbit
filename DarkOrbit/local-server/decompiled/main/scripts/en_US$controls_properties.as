package
{
   import mx.resources.ResourceBundle;
   
   public class en_US$controls_properties extends ResourceBundle
   {
      
      public function en_US$controls_properties()
      {
         super("en_US","controls");
      }
      
      override protected function getContent() : Object
      {
         return {
            "noLabel":"No",
            "dayNamesShortest":"S,M,T,W,T,F,S",
            "missingAttributeSrc":"URL: \'{0}\' Attribute src is required in \'{1}\' tag.",
            "unknownInput":"Unknown inputType \'{0}\'.",
            "tagNotFound":"URL: \'{0}\' At least one video of ref tag is required.",
            "undefinedArray":"CuePoint.array undefined.",
            "badArgs":"Bad args to _play.",
            "wrongTimeName":"Time must be number and/or name must not be undefined or null.",
            "wrongDisabled":"Disabled must be number.",
            "wrongIndex":"CuePoint.index must be number between -1 and cuePoint.array.length.",
            "yesLabel":"Yes",
            "nullURL":"Null URL sent to VideoPlayer.load.",
            "wrongFormat":"Unexpected cuePoint parameter format.",
            "incorrectType":"Type must be 0, 1 or 2.",
            "unexpectedEnd":"Unexpected end of cuePoint param string.",
            "requiredField":"Required Field",
            "wrongNumParams":"Num params must be number.",
            "invalidCall":"Cannot call reconnect on an http connection.",
            "errWrongType":"ERROR: The dataProvider of \'{0}\' must be String, ViewStack, Array, or IList.",
            "cancelLabel":"Cancel",
            "notfpad":"URL: \'{0}\' Root node not fpad.",
            "wrongTime":"Time must be number.",
            "errWrongContainer":"ERROR: The dataProvider of \'{0}\' must not contain objects of type flash.display.DisplayObject.",
            "label":"LOADING %3%%",
            "unsupportedMode":"IMEMode \'{0}\' not supported.",
            "notImplemented":"\'{0}\' not implemented yet.",
            "errorMessages":"Unable to make connection to server or to find FLV on server.,No matching cue point found.,Illegal cue point.,Invalid seek.,Invalid contentPath.,Invalid XML.,No bitrate match; must be no default FLV.,Cannot delete default VideoPlayer.",
            "notLoadable":"Unable to load \'{0}\'.",
            "missingAttributes":"URL: \'{0}\' Tag \'{1}\' requires attributes id, width, and height. Width and height must be numbers greater than or equal to 0.",
            "missingRoot":"URL: \'{0}\' No root node found; if URL is for an FLV, it must have a .flv extension and take no parameters.",
            "rootNotSMIL":"URL: \'{0}\' Root node not smil: \'{1}\'.",
            "firstDayOfWeek":"0",
            "wrongName":"Name cannot be undefined or null.",
            "wrongType":"Type must be number.",
            "yearSymbol":"",
            "undefinedParameter":"CuePoint parameter undefined.",
            "cannotDisable":"Cannot disable actionscript cue points.",
            "missingProxy":"URL: \'{0}\' fpad xml requires proxy tag.",
            "okLabel":"OK",
            "rootNotFound":"URL: \'{0}\' No root node found; if file is an flv, it must have a .flv extension."
         };
      }
   }
}

