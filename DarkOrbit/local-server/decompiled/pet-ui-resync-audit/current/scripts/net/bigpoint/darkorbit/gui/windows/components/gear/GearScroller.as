package net.bigpoint.darkorbit.gui.windows.components.gear
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class GearScroller extends Sprite
   {
      
      public static const SECOND_COMBO_BOX_X_POS:int = 135;
      
      public static const TOP_EMBED_BITMAP_ID:String = "top.png";
      
      public static const BOTTOM_EMBED_BITMAP_ID:String = "down.png";
      
      public static const UI_FINISHER_ID:String = "ui";
      
      private var _comboBoxBodyFirstTop:Bitmap;
      
      private var _comboBoxBodyFirstBottom:Bitmap;
      
      private var _comboBoxBodySecondTop:Bitmap;
      
      private var _comboBoxBodySecondBottom:Bitmap;
      
      private var _firstContainer:Sprite;
      
      private var _secondContainer:Sprite;
      
      private var _splitBorder:int;
      
      private var _items:Array = [];
      
      private var _gearID:int;
      
      public function GearScroller(param1:int = -1, param2:int = -1)
      {
         super();
         this.visible = false;
         this._gearID = param1;
         this._splitBorder = param2;
         this.init();
      }
      
      public function get gearID() : int
      {
         return this._gearID;
      }
      
      public function get itemsCount() : int
      {
         return this._splitBorder > 0 ? this._splitBorder : int(this._items.length);
      }
      
      public function addElement(param1:GearItem) : void
      {
         var _loc2_:int = 0;
         param1.parentgearID = this.gearID;
         if(this._splitBorder < 0 || this._firstContainer.numChildren < this._splitBorder)
         {
            this._firstContainer.addChild(param1);
            _loc2_ = this.getBottomPosition(this._firstContainer);
            this._comboBoxBodyFirstBottom.y = _loc2_ + this._comboBoxBodyFirstTop.height;
            this._comboBoxBodyFirstTop.visible = this._comboBoxBodyFirstBottom.visible = true;
         }
         else
         {
            this._secondContainer.addChild(param1);
            _loc2_ = this.getBottomPosition(this._secondContainer);
            this._comboBoxBodySecondBottom.y = _loc2_ + this._comboBoxBodySecondTop.height;
            this._comboBoxBodySecondTop.visible = this._comboBoxBodySecondBottom.visible = true;
         }
         this._items.push(param1);
      }
      
      public function removeElement(param1:GearItem) : void
      {
         var _loc2_:GearItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc2_ = this._items[_loc3_];
            if(_loc2_ != null && _loc2_.gearID == param1.gearID)
            {
               if(this._firstContainer.contains(_loc2_))
               {
                  this._firstContainer.removeChild(_loc2_);
               }
               else if(this._splitBorder > 0)
               {
                  this._secondContainer.removeChild(_loc2_);
               }
               this._items[_loc3_] = null;
            }
            _loc3_++;
         }
         this.invalidateSubMenuVerticalItems();
      }
      
      public function removeAllElements() : void
      {
         while(this._firstContainer.numChildren > 0)
         {
            this._firstContainer.removeChildAt(this._firstContainer.numChildren - 1);
         }
         this._comboBoxBodyFirstTop.visible = this._comboBoxBodyFirstBottom.visible = false;
         if(this._splitBorder > 0)
         {
            while(this._secondContainer.numChildren > 0)
            {
               this._secondContainer.removeChildAt(this._secondContainer.numChildren - 1);
            }
            this._comboBoxBodySecondTop.visible = this._comboBoxBodySecondBottom.visible = false;
         }
         this._items = [];
      }
      
      public function show() : void
      {
         this.visible = true;
      }
      
      public function hide() : void
      {
         this.visible = false;
      }
      
      public function toggleVisibility() : void
      {
         this.visible = !this.visible;
      }
      
      public function getElement(param1:int) : GearItem
      {
         return this._items[param1] as GearItem;
      }
      
      public function getElementByID(param1:int) : GearItem
      {
         var _loc2_:GearItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < this._items.length)
         {
            _loc2_ = this._items[_loc3_] as GearItem;
            if(_loc2_ != null && _loc2_.gearID == param1)
            {
               return _loc2_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function invalidateSubMenuVerticalItems() : void
      {
         var _loc1_:int = 0;
         if(this._firstContainer.numChildren == 0)
         {
            this._comboBoxBodyFirstTop.visible = this._comboBoxBodyFirstBottom.visible = false;
         }
         else
         {
            _loc1_ = this.getBottomPosition(this._firstContainer) + this._comboBoxBodyFirstTop.height;
            if(this._comboBoxBodyFirstBottom.y != _loc1_)
            {
               this._comboBoxBodyFirstBottom.y = _loc1_;
            }
         }
         if(this._splitBorder > 0)
         {
            if(this._secondContainer.numChildren == 0)
            {
               this._comboBoxBodySecondTop.visible = this._comboBoxBodySecondBottom.visible = false;
            }
            else
            {
               _loc1_ = this.getBottomPosition(this._secondContainer) + this._comboBoxBodySecondTop.height;
               if(this._comboBoxBodySecondBottom.y != _loc1_)
               {
                  this._comboBoxBodySecondBottom.y = _loc1_;
               }
            }
         }
      }
      
      protected function init() : void
      {
         this.addFirstComboBox();
         if(this._splitBorder > 0)
         {
            this.addSecondComboBox();
         }
      }
      
      protected function addFirstComboBox() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(UI_FINISHER_ID));
         this._comboBoxBodyFirstTop = _loc1_.getEmbeddedBitmap(TOP_EMBED_BITMAP_ID);
         this._comboBoxBodyFirstTop.visible = false;
         this._comboBoxBodyFirstBottom = _loc1_.getEmbeddedBitmap(BOTTOM_EMBED_BITMAP_ID);
         this._comboBoxBodyFirstBottom.x = -1;
         this._comboBoxBodyFirstBottom.visible = false;
         this._firstContainer = new Sprite();
         this._firstContainer.y = this._comboBoxBodyFirstTop.height;
         this.addChild(this._comboBoxBodyFirstTop);
         this.addChild(this._comboBoxBodyFirstBottom);
         this.addChild(this._firstContainer);
      }
      
      protected function addSecondComboBox() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher(UI_FINISHER_ID));
         this._comboBoxBodySecondTop = _loc1_.getEmbeddedBitmap(TOP_EMBED_BITMAP_ID);
         this._comboBoxBodySecondTop.x = SECOND_COMBO_BOX_X_POS;
         this._comboBoxBodySecondTop.visible = false;
         this._comboBoxBodySecondBottom = _loc1_.getEmbeddedBitmap(BOTTOM_EMBED_BITMAP_ID);
         this._comboBoxBodySecondBottom.x = SECOND_COMBO_BOX_X_POS - 1;
         this._comboBoxBodySecondBottom.visible = false;
         this._secondContainer = new Sprite();
         this._secondContainer.y = this._comboBoxBodySecondTop.height;
         this._secondContainer.x = SECOND_COMBO_BOX_X_POS;
         this.addChild(this._comboBoxBodySecondTop);
         this.addChild(this._comboBoxBodySecondBottom);
         this.addChild(this._secondContainer);
      }
      
      protected function getBottomPosition(param1:Sprite) : int
      {
         var _loc3_:GearItem = null;
         var _loc2_:int = 0;
         var _loc4_:int = param1.numChildren;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc3_ = GearItem(param1.getChildAt(_loc5_));
            if(_loc3_ != null)
            {
               _loc3_.y = _loc2_;
               _loc2_ += _loc3_.height;
            }
            _loc5_++;
         }
         return _loc2_;
      }
   }
}

