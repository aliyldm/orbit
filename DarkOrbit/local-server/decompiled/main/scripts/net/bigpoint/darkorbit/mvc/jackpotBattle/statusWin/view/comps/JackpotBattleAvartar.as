package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.comps
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   
   public class JackpotBattleAvartar extends SimpleElement
   {
      
      private var _avatarName:TextFieldElement;
      
      private var _boarderImg:DisplayObject = new Shape();
      
      private var _avartarImg:DisplayObject = new Shape();
      
      private var _backgroundImg:DisplayObject = new Shape();
      
      private var _picOffset:PointLite = new PointLite();
      
      private var _nameOffset:int;
      
      public function JackpotBattleAvartar(param1:int = 0, param2:int = 0)
      {
         super(SimpleElement.TYPE_JACKPOT_BATTLE_AVATAR);
         this._picOffset.x = param1;
         this._picOffset.y = param2;
         this.init();
      }
      
      private function init() : void
      {
         addChild(this._backgroundImg);
         addChild(this._boarderImg);
         addChild(this._avartarImg);
         this.addNameTextField();
      }
      
      private function addNameTextField() : void
      {
         this._avatarName = new TextFieldElement(width,40,Styles.infoFieldFmt);
         this.updateTextFieldPosition();
         addChild(this._avatarName);
      }
      
      private function updateTextFieldPosition() : void
      {
         this._avatarName.tfWidth = width;
         this._avatarName.y = this._nameOffset - this._avatarName.textField.textHeight * 0.5;
      }
      
      public function set boarder(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = this.exchangeDisplayObjects(this._boarderImg,param1);
         if(_loc2_)
         {
            this._boarderImg = param1;
            this.updateTextFieldPosition();
         }
      }
      
      public function set avartar(param1:DisplayObject) : void
      {
         var _loc2_:Boolean = this.exchangeDisplayObjects(this._avartarImg,param1);
         if(_loc2_)
         {
            this._avartarImg = param1;
            this._avartarImg.alpha = 0;
            this.updateAvartarPosition();
         }
         TweenMax.to(this._avartarImg,1,{"alpha":1});
      }
      
      public function get avartar() : DisplayObject
      {
         return this._avartarImg;
      }
      
      public function set background(param1:DisplayObject) : void
      {
         this.exchangeDisplayObjects(this._backgroundImg,param1);
         this._backgroundImg = param1;
      }
      
      public function set picOffsetX(param1:int) : void
      {
         if(param1 != this._picOffset.x)
         {
            this._picOffset.x = param1;
            this.updateAvartarPositionX();
         }
      }
      
      public function set picOffsetY(param1:int) : void
      {
         if(param1 != this._picOffset.y)
         {
            this._picOffset.y = param1;
            this.updateAvartarPositionY();
         }
      }
      
      private function exchangeDisplayObjects(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:int = 0;
         param2 = Boolean(param2) && param2 != param1 ? param2 : null;
         if(param2)
         {
            if(Boolean(param1) && Boolean(param1.parent))
            {
               _loc3_ = param1.parent;
               _loc4_ = param1.parent.getChildIndex(param1);
               _loc3_.addChildAt(param2,_loc4_);
               _loc3_.removeChild(param1);
            }
         }
         return Boolean(param2);
      }
      
      private function updateAvartarPosition() : void
      {
         this.updateAvartarPositionX();
         this.updateAvartarPositionY();
      }
      
      private function updateAvartarPositionY() : void
      {
         this._avartarImg.y = this._picOffset.y;
      }
      
      private function updateAvartarPositionX() : void
      {
         this._avartarImg.x = this._picOffset.x;
      }
      
      public function updateName(param1:String) : void
      {
         this._avatarName.updateText(param1);
         this.updateTextFieldPosition();
      }
      
      public function set nameOffset(param1:int) : void
      {
         if(this._nameOffset != param1)
         {
            this._nameOffset = param1;
            this.updateTextFieldPosition();
         }
      }
   }
}

