package net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.model.vo
{
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMResultWindowTabVo;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.view.window.components.vo.TDMRewardsModel;
   
   public class TDMResultWindowModel
   {
      
      private var _tabs:Vector.<TDMResultWindowTabVo>;
      
      private var _rewards:TDMRewardsModel;
      
      private var _hint:String;
      
      public function TDMResultWindowModel(param1:Vector.<TDMResultWindowTabVo>, param2:TDMRewardsModel, param3:String)
      {
         super();
         this._hint = param3;
         this._rewards = param2;
         this._tabs = param1;
      }
      
      public function get tabs() : Vector.<TDMResultWindowTabVo>
      {
         return this._tabs;
      }
      
      public function get rewards() : TDMRewardsModel
      {
         return this._rewards;
      }
      
      public function get hint() : String
      {
         return this._hint;
      }
   }
}

