package net.bigpoint.darkorbit.mvc.chatclient.view.richtext
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import net.bigpoint.darkorbit.fui.builder.repository.TextStyleVO;
   import net.bigpoint.darkorbit.mvc.chatclient.view.ChatUIIconSkinFactory;
   
   public class RichChatFactionIcon extends Sprite
   {
      
      private var _factionId:int;
      
      public function RichChatFactionIcon(param1:int, param2:TextStyleVO)
      {
         super();
         this._factionId = param1;
         mouseEnabled = false;
         mouseChildren = false;
         if(this._factionId == 0)
         {
            return;
         }
         if(this.addFactionBitmap(param2))
         {
            return;
         }
         this.addPlaceholder(param2);
      }
      
      public function get factionId() : int
      {
         return this._factionId;
      }
      
      private function addFactionBitmap(param1:TextStyleVO) : Boolean
      {
         var bitmapData:BitmapData = null;
         var bitmap:Bitmap = null;
         var maxSize:Number = NaN;
         var scale:Number = NaN;
         var style:TextStyleVO = param1;
         if(this._factionId == 0)
         {
            return false;
         }
         try
         {
            bitmapData = ChatUIIconSkinFactory.getFactionIconBitmapData(this._factionId);
            if(!bitmapData)
            {
               return false;
            }
            bitmap = new Bitmap(bitmapData);
            maxSize = 20;
            scale = Math.min(1,maxSize / bitmap.width,maxSize / bitmap.height);
            bitmap.scaleX = scale;
            bitmap.scaleY = scale;
            bitmap.smoothing = true;
            addChild(bitmap);
            return true;
         }
         catch(error:Error)
         {
            return false;
         }
      }
      
      private function addPlaceholder(param1:TextStyleVO) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         param1.assign(_loc2_);
         _loc2_.text = "*";
         addChild(_loc2_);
      }
   }
}

