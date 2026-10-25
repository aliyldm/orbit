package net.bigpoint.darkorbit.mvc.settingsFUI.model
{
   public class SettingsSliderNStepsItemVO
   {
      
      public static const SETTINGS_SLIDER_N_STEPS_ID_PRESETTINGS:int = 1001;
      
      public static const SETTINGS_SLIDER_N_STEPS_ID_SOUND_EFFECTS_VOLUME:int = 4001;
      
      public static const SETTINGS_SLIDER_N_STEPS_ID_MUSIC_VOLUME:int = 4002;
      
      public static const SETTINGS_SLIDER_N_STEPS_ID_BOARDCOMPUTER_VOLUME:int = 4003;
      
      private var _sliderNStepsId:int;
      
      private var _sliderValue:int;
      
      private var _sliderMaxValue:int;
      
      public function SettingsSliderNStepsItemVO(param1:int, param2:int, param3:int)
      {
         super();
         this._sliderNStepsId = param1;
         this._sliderValue = param2;
         this._sliderMaxValue = param3;
      }
      
      public function get sliderNStepsId() : int
      {
         return this._sliderNStepsId;
      }
      
      public function get sliderValue() : int
      {
         return this._sliderValue;
      }
      
      public function get sliderMaxValue() : int
      {
         return this._sliderMaxValue;
      }
   }
}

