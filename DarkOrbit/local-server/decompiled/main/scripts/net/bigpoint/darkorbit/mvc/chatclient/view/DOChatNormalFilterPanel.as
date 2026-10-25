package net.bigpoint.darkorbit.mvc.chatclient.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatRoomVO;
   import org.osflash.signals.Signal;
   
   public class DOChatNormalFilterPanel extends Sprite
   {
      
      private static const PADDING:int = 6;
      
      private static const HEADER_HEIGHT:int = 20;
      
      private static const ROW_HEIGHT:int = 20;
      
      private static const CHECK_SIZE:int = 11;
      
      private static const MIN_WIDTH:int = 120;
      
      public const selectionChanged:Signal = new Signal(String,Boolean);
      
      private var _rooms:Vector.<DOChatRoomVO> = new Vector.<DOChatRoomVO>();
      
      private var _selectionByPath:Dictionary = new Dictionary();
      
      private var _rowPathBySprite:Dictionary = new Dictionary(true);
      
      private var _contentWidth:int = 120;
      
      public function DOChatNormalFilterPanel()
      {
         super();
         mouseEnabled = true;
         mouseChildren = true;
         visible = false;
      }
      
      public function setRooms(param1:Vector.<DOChatRoomVO>, param2:Dictionary) : void
      {
         this._rooms = param1 != null ? param1.concat() : new Vector.<DOChatRoomVO>();
         this._selectionByPath = param2 != null ? param2 : new Dictionary();
         this.redraw();
      }
      
      public function isRoomSelected(param1:DOChatRoomVO) : Boolean
      {
         return param1 != null && this._selectionByPath[param1.path] !== false;
      }
      
      private function redraw() : void
      {
         var _loc2_:DOChatRoomVO = null;
         var _loc3_:int = 0;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this._rowPathBySprite = new Dictionary(true);
         var _loc1_:String = BPLocale.getItemInCategory("chat","chat_choose_channel");
         this._contentWidth = Math.max(MIN_WIDTH,this.measureText(_loc1_) + PADDING * 2);
         for each(_loc2_ in this._rooms)
         {
            this._contentWidth = Math.max(this._contentWidth,this.measureText(_loc2_.translatedName) + 30);
         }
         _loc3_ = PADDING * 2 + HEADER_HEIGHT + Math.max(1,this._rooms.length) * ROW_HEIGHT;
         graphics.clear();
         graphics.lineStyle(1,47080,1);
         graphics.beginFill(202269,0.95);
         graphics.drawRect(0,0,this._contentWidth,_loc3_);
         graphics.endFill();
         this.addLabel(_loc1_,PADDING,PADDING + 1,12580863);
         if(this._rooms.length == 0)
         {
            this.addLabel("-",PADDING + 18,PADDING + HEADER_HEIGHT + 2,7320267);
            return;
         }
         var _loc4_:int = 0;
         while(_loc4_ < this._rooms.length)
         {
            this.addRow(this._rooms[_loc4_],PADDING,PADDING + HEADER_HEIGHT + _loc4_ * ROW_HEIGHT);
            _loc4_++;
         }
      }
      
      private function addRow(param1:DOChatRoomVO, param2:int, param3:int) : void
      {
         var _loc4_:Sprite = new Sprite();
         _loc4_.x = param2;
         _loc4_.y = param3;
         _loc4_.buttonMode = true;
         _loc4_.useHandCursor = true;
         _loc4_.mouseChildren = false;
         this._rowPathBySprite[_loc4_] = param1.path;
         _loc4_.addEventListener(MouseEvent.CLICK,this.handleRowClicked);
         addChild(_loc4_);
         _loc4_.graphics.beginFill(0,0);
         _loc4_.graphics.drawRect(0,0,this._contentWidth - PADDING * 2,ROW_HEIGHT);
         _loc4_.graphics.endFill();
         this.drawCheck(_loc4_,0,4,this.isRoomSelected(param1));
         this.addLabel(param1.translatedName,18,1,15327936,_loc4_);
      }
      
      private function drawCheck(param1:Sprite, param2:int, param3:int, param4:Boolean) : void
      {
         param1.graphics.lineStyle(1,47080,1);
         param1.graphics.beginFill(7720,1);
         param1.graphics.drawRect(param2,param3,CHECK_SIZE,CHECK_SIZE);
         param1.graphics.endFill();
         if(!param4)
         {
            return;
         }
         param1.graphics.lineStyle(2,12580863,1);
         param1.graphics.moveTo(param2 + 2,param3 + 6);
         param1.graphics.lineTo(param2 + 5,param3 + 9);
         param1.graphics.lineTo(param2 + 10,param3 + 2);
      }
      
      private function addLabel(param1:String, param2:int, param3:int, param4:uint, param5:Sprite = null) : TextField
      {
         var _loc6_:TextField = new TextField();
         _loc6_.defaultTextFormat = new TextFormat("Verdana",9,param4);
         _loc6_.text = param1;
         _loc6_.width = this._contentWidth - param2 - PADDING;
         _loc6_.height = 18;
         _loc6_.x = param2;
         _loc6_.y = param3;
         _loc6_.selectable = false;
         _loc6_.mouseEnabled = false;
         var _loc7_:Sprite = param5 != null ? param5 : this;
         _loc7_.addChild(_loc6_);
         return _loc6_;
      }
      
      private function measureText(param1:String) : int
      {
         var _loc2_:TextField = new TextField();
         _loc2_.defaultTextFormat = new TextFormat("Verdana",9,16777215);
         _loc2_.text = param1 != null ? param1 : "";
         return int(_loc2_.textWidth + 6);
      }
      
      private function handleRowClicked(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = param1.currentTarget as Sprite;
         var _loc3_:String = this._rowPathBySprite[_loc2_];
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:Boolean = this._selectionByPath[_loc3_] === false;
         this._selectionByPath[_loc3_] = _loc4_;
         this.selectionChanged.dispatch(_loc3_,_loc4_);
         this.redraw();
      }
   }
}

