package net.bigpoint.darkorbit.map.hud.effects
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.common.AbstractViewEffectsManager;
   import net.bigpoint.darkorbit.map.hud.effects.impl.AlertEffect2D;
   import net.bigpoint.darkorbit.map.hud.effects.impl.DamagedReceivedEffect2D;
   import net.bigpoint.darkorbit.map.hud.effects.impl.EmoteEffect2D;
   import net.bigpoint.darkorbit.map.hud.effects.impl.KillCounterEffect2D;
   import net.bigpoint.darkorbit.map.hud.effects.impl.PointingArrowEffect2D;
   import net.bigpoint.darkorbit.map.hud.effects.impl.TimerCountdownEffect2D;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class HudEffectsManager extends AbstractViewEffectsManager
   {
      
      private const _map:Object = {};
      
      private var _view:IMapView;
      
      private var _container:DisplayObjectContainer;
      
      public function HudEffectsManager(param1:IMapView, param2:DisplayObjectContainer)
      {
         this._view = param1;
         this._container = param2;
         this.addMapping(EffectIDList.DAMAGE_RECIEVED_EFFECT,DamagedReceivedEffect2D);
         this.addMapping(EffectIDList.POINTING_ARROW,PointingArrowEffect2D);
         this.addMapping(EffectIDList.TIMER_COUNTDOWN,TimerCountdownEffect2D);
         this.addMapping(EffectIDList.ALERT_EFFECT,AlertEffect2D);
         this.addMapping(EffectIDList.KILL_COUNTER_EFFECT,KillCounterEffect2D);
         this.addMapping(EffectIDList.EMOTE_EFFECT,EmoteEffect2D);
         super();
      }
      
      public function addMapping(param1:int, param2:Class) : void
      {
         this._map[param1] = param2;
      }
      
      override protected function buildEffect(param1:Effect) : Object
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:Class = this._map[param1.id] as Class;
         if(_loc2_ != null)
         {
            _loc3_ = new _loc2_(this._view,param1) as DisplayObject;
            this._container.addChild(_loc3_);
         }
         return _loc3_;
      }
   }
}

