package net.bigpoint.darkorbit.mvc.chatclient.view.report
{
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatMessageVO;
   import net.bigpoint.darkorbit.mvc.chatclient.view.richtext.RichChatMessageRow;
   
   internal class ReportMessageContent extends Sprite
   {
      
      public function ReportMessageContent(param1:DOChatMessageVO, param2:Number, param3:Number, param4:String, param5:String)
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         var _loc6_:Number = Math.max(20,param2);
         var _loc7_:Number = Math.max(1,param3);
         scrollRect = new Rectangle(0,0,_loc6_,_loc7_);
         var _loc8_:RichChatMessageRow = new RichChatMessageRow(param1,_loc6_,param4,false,param5);
         _loc8_.y = Math.max(0,(_loc7_ - _loc8_.height) * 0.5);
         addChild(_loc8_);
      }
   }
}

