package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.delete_in_eic.BitmapVO;
   import net.bigpoint.darkorbit.delete_in_eic.BitmapVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ArmoryUnlockCard extends Sprite
   {
      
      public static const ww:int = 100;
      
      public static const hh:int = 130;
      
      public static const iconW:int = 76;
      
      private static const cards:Dictionary = new Dictionary();
      
      private var img:Bitmap = new Bitmap();
      
      private var url:String;
      
      public var imgW:int = 96;
      
      public var imgH:int = 123;
      
      protected var nameLabel:TextField = new TextField();
      
      protected var amountLabel:TextField = new TextField();
      
      private var loader:BitmapVOLoader = new BitmapVOLoader();
      
      private var icon:Sprite = new Sprite();
      
      public var btn:Button = new Button();
      
      public function ArmoryUnlockCard(param1:String, param2:BitmapData = null)
      {
         super();
         this.url = param1;
         this.addChild(this.img);
         this.img.x = (ArmoryUnlockCard.ww - this.imgW) / 2;
         this.img.y = (ArmoryUnlockCard.hh - this.imgH) / 2;
         this.graphics.beginFill(0,0);
         this.graphics.drawRect(0,0,ArmoryUnlockCard.ww,ArmoryUnlockCard.hh);
         this.width = ArmoryUnlockCard.ww;
         this.height = ArmoryUnlockCard.hh;
         if(param2 != null)
         {
            this.img.bitmapData = param2;
         }
         else
         {
            this.setSkin(param1);
         }
         this.addChild(this.icon);
         this.icon.x = (ArmoryUnlockCard.ww - ArmoryUnlockCard.iconW) / 2;
         this.icon.y = (ArmoryUnlockCard.hh - ArmoryUnlockCard.iconW) / 2;
         this.icon.graphics.beginFill(0,0);
         this.icon.graphics.drawRect(0,0,iconW,iconW);
         this.icon.graphics.endFill();
         this.btn.width = ArmoryUnlockCard.ww;
         this.btn.height = ArmoryUnlockCard.hh;
         this.btn.graphics.beginFill(16711680,0);
         this.btn.graphics.drawRect(0,0,ArmoryUnlockCard.ww,ArmoryUnlockCard.hh);
         this.btn.graphics.endFill();
         this.btn.mouseEnabled = true;
         this.addChild(this.btn);
      }
      
      public static function GetCard(param1:String) : ArmoryUnlockCard
      {
         var _loc2_:String = Settings.staticHost + "do_img/global/events/cannon/" + param1 + ".png";
         var _loc3_:Vector.<ArmoryUnlockCard> = cards[_loc2_];
         if(_loc3_ == null)
         {
            _loc3_ = new Vector.<ArmoryUnlockCard>();
            ArmoryUnlockCard.cards[_loc2_] = _loc3_;
         }
         if(_loc3_.length > 0)
         {
            return _loc3_.shift();
         }
         return new ArmoryUnlockCard(_loc2_);
      }
      
      private function setSkin(param1:String) : void
      {
         this.loader.addEventListener(BitmapVO.EVENT_COMPLETE,this.imgOk);
         this.loader.getRes(param1);
      }
      
      private function imgOk(param1:BitmapVO) : void
      {
         var _loc2_:BitmapData = param1.getBitmapData();
         this.img.bitmapData = _loc2_;
      }
      
      public function recover() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this.icon.removeChildren();
         if(ArmoryUnlockCard.cards[this.url])
         {
            ArmoryUnlockCard.cards[this.url].push(this);
         }
      }
      
      public function setData(param1:ItemVO, param2:int, param3:ShipPattern) : void
      {
         IconVOLoader.getInstance().loadIcon(this.icon,param1,"100x100",AssetsProxy.ITEMS);
         var _loc4_:int = 18;
         this.nameLabel.visible = false;
         this.nameLabel.mouseEnabled = false;
         var _loc5_:Number = 0;
         if(param3)
         {
            this.nameLabel.visible = true;
            this.nameLabel.autoSize = TextFieldAutoSize.LEFT;
            this.nameLabel.selectable = false;
            this.nameLabel.defaultTextFormat = new TextFormat("Verdana",8,16777215);
            this.nameLabel.text = param3.name;
            while(this.nameLabel.textWidth + 4 > ArmoryUnlockCard.ww)
            {
               _loc4_ -= 2;
               this.nameLabel.defaultTextFormat = new TextFormat("Verdana",_loc4_,16777215);
               this.nameLabel.text = param1.fullname;
               if(_loc4_ <= 6)
               {
                  break;
               }
            }
            _loc5_ = Math.min(ArmoryUnlockCard.ww,this.nameLabel.textWidth + 4);
            this.nameLabel.x = (ArmoryUnlockCard.ww - _loc5_) / 2;
            this.nameLabel.y = 15;
            this.nameLabel.textColor = 16777215;
            this.addChild(this.nameLabel);
         }
         this.amountLabel.mouseEnabled = false;
         this.amountLabel.autoSize = TextFieldAutoSize.LEFT;
         this.amountLabel.selectable = false;
         this.amountLabel.text = "x " + param2;
         this.amountLabel.textColor = 16777215;
         _loc5_ = Math.min(ArmoryUnlockCard.ww,this.amountLabel.textWidth + 4);
         this.amountLabel.x = (ArmoryUnlockCard.ww - _loc5_) / 2;
         this.amountLabel.y = ArmoryUnlockCard.hh - (15 + this.amountLabel.textHeight);
         this.addChild(this.amountLabel);
         this.btn.tooltipData = "" + param1.fullname + "\n" + param1.rawDescription;
      }
   }
}

