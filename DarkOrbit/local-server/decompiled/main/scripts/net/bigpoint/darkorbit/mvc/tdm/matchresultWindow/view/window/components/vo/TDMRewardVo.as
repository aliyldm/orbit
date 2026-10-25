package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo
{
   public class TDMRewardVo
   {
      
      private var _rewardText:String;
      
      private var _ammount:String;
      
      public function TDMRewardVo(param1:String, param2:String)
      {
         super();
         this._rewardText = param1;
         this._ammount = param2;
      }
      
      public function get rewardText() : String
      {
         return this._rewardText;
      }
      
      public function get ammount() : String
      {
         return this._ammount;
      }
   }
}

