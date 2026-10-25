package net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.decorator
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.mvc.jackpotBattle.statusWin.view.comps.JackpotBattleAvartar;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class JackpotStatusCenterDecorator
   {
      
      private static const STD_BOAREDOFFSET_Y:int = 42;
      
      private static const STD_NAMEOFFSET_Y:int = 6;
      
      private var _centerContainer:SimpleContainer;
      
      private var _width:Number;
      
      private var _height:Number;
      
      private var _jackpotBattleHeroAvatar:JackpotBattleAvartar = new JackpotBattleAvartar();
      
      private var _jackpotBattleOpponentAvatar:JackpotBattleAvartar = new JackpotBattleAvartar();
      
      private var _vsSeparatorIcon:Sprite;
      
      public function JackpotStatusCenterDecorator(param1:SimpleContainer, param2:Number, param3:Number)
      {
         super();
         this._height = param3;
         this._width = param2;
         this._centerContainer = param1;
         this.createCenterContent();
      }
      
      private function createCenterContent() : void
      {
         this.addHeroAvatar();
         this.addVSSeparator();
         this.addOpponentAvatar();
      }
      
      private function addOpponentAvatar() : void
      {
         this._jackpotBattleOpponentAvatar.boarder = this.getDebugAsset(154,193);
         this._jackpotBattleOpponentAvatar.picOffsetY = STD_BOAREDOFFSET_Y;
         this._jackpotBattleOpponentAvatar.nameOffset = STD_NAMEOFFSET_Y;
         this._centerContainer.addElement(this._jackpotBattleOpponentAvatar,SimpleContainer.ALIGN_HORIZONTAL_CENTER);
      }
      
      private function addVSSeparator() : void
      {
         this._vsSeparatorIcon = this.getDebugAsset(63,35);
         this._centerContainer.addElement(this._vsSeparatorIcon,SimpleContainer.ALIGN_HORIZONTAL_CENTER);
      }
      
      private function addHeroAvatar() : void
      {
         this._jackpotBattleHeroAvatar.boarder = this.getDebugAsset(154,193);
         this._jackpotBattleHeroAvatar.picOffsetY = STD_BOAREDOFFSET_Y;
         this._jackpotBattleHeroAvatar.nameOffset = STD_NAMEOFFSET_Y;
         this._centerContainer.addElement(this._jackpotBattleHeroAvatar,SimpleContainer.ALIGN_HORIZONTAL_CENTER);
      }
      
      private function getDebugAsset(param1:int = 100, param2:int = 100) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.drawRect(0,0,param1,param2);
         return _loc3_;
      }
      
      public function get jackpotBattleHeroAvatar() : JackpotBattleAvartar
      {
         return this._jackpotBattleHeroAvatar;
      }
      
      public function get jackpotBattleOpponentAvatar() : JackpotBattleAvartar
      {
         return this._jackpotBattleOpponentAvatar;
      }
      
      public function get vsLogo() : DisplayObject
      {
         return this._vsSeparatorIcon;
      }
      
      public function set vsLogo(param1:DisplayObject) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._vsSeparatorIcon);
         this._vsSeparatorIcon.addChild(param1);
      }
   }
}

