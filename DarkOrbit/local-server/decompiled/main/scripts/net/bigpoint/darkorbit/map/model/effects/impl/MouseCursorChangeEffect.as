package net.bigpoint.darkorbit.map.model.effects.impl
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.system.manager.mouse.IMouseManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   
   public class MouseCursorChangeEffect extends Effect implements IFrameObserver
   {
      
      private static const MOUSECURSOR_NAME:String = "MouseCursorChangeEffect";
      
      private var _libId:String;
      
      private var _linkageID:String;
      
      private var _active:Boolean = false;
      
      public function MouseCursorChangeEffect(param1:String, param2:String)
      {
         super(EffectIDList.MOUSECURSOR_CHANGE_EFFECT,PERSISTANT);
         this._libId = param1;
         this._linkageID = param2;
      }
      
      override public function activate() : Boolean
      {
         var _loc1_:Boolean = super.activate();
         ScreenManager.addObserver(this);
         this._active = true;
         this.updateCursor();
         return _loc1_;
      }
      
      override public function reactivate(param1:Effect) : void
      {
         this._libId = MouseCursorChangeEffect(param1)._libId;
         this._linkageID = MouseCursorChangeEffect(param1)._linkageID;
         this.updateCursor();
      }
      
      override public function deactivate() : void
      {
         this._active = false;
         ScreenManager.removeObserver(this);
         this.mouseManager.hideCustomCursor();
         this.mouseManager.unregisterMouseCursor(MOUSECURSOR_NAME);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:ScreenManager = ScreenManager.getInstance();
         var _loc4_:MouseHitAreaTrait = _loc3_.eventManager.hitTestResolver.currentlyHovered;
         var _loc5_:Ship = _loc4_ ? _loc4_.owner as Ship : null;
         if(_loc5_ != null && _loc5_ != _loc3_.map.getShipManager().getSelectedShip())
         {
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.mouseManager.showCustomCursor(MOUSECURSOR_NAME);
         }
         else
         {
            this.mouseManager.hideCustomCursor();
         }
      }
      
      private function updateCursor() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Matrix = null;
         if(this._active)
         {
            if(ResourceManager.isLoaded(this._libId))
            {
               _loc1_ = ResourceManager.getMovieClip(this._libId,this._linkageID);
               _loc2_ = new BitmapData(32,32,true,0);
               _loc3_ = new Matrix();
               _loc3_.translate(16,16);
               _loc2_.draw(_loc1_,_loc3_);
               this.mouseManager.hideCustomCursor();
               this.mouseManager.unregisterMouseCursor(MOUSECURSOR_NAME);
               this.mouseManager.registerMouseCursor(MOUSECURSOR_NAME,new Bitmap(_loc2_));
            }
            else
            {
               ResourceManager.loadAndCall(this._libId,this.updateCursor,[]);
            }
         }
      }
      
      private function get mouseManager() : IMouseManager
      {
         return UISystem.getInstance().mouseManager;
      }
   }
}

