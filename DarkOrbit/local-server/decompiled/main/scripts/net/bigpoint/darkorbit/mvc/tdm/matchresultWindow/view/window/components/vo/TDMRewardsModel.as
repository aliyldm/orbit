package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo
{
   public class TDMRewardsModel
   {
      
      private var _rewardList:Vector.<TDMRewardVo>;
      
      private var _title:String;
      
      private var _message:String;
      
      public function TDMRewardsModel(param1:Vector.<TDMRewardVo>, param2:String, param3:String)
      {
         super();
         this._title = param2;
         this._rewardList = param1;
         this._message = param3;
      }
      
      public function get rewardList() : Vector.<TDMRewardVo>
      {
         return this._rewardList;
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      public function get message() : String
      {
         return this._message;
      }
   }
}

