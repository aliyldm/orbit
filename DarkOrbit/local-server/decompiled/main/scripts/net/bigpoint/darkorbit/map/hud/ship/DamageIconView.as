package net.bigpoint.darkorbit.map.hud.ship
{
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.traits.hud.DamageIconTrait;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DamageIconView extends AbstractIconView
   {
      
      private static const MAPPING:Array = [];
      
      MAPPING[DamageIconTrait.BUFF] = "dmgBuff";
      MAPPING[DamageIconTrait.DEBUFF] = "dmgDebuff";
      
      private var _trait:DamageIconTrait;
      
      private var _mc:MovieClip;
      
      public function DamageIconView(param1:DamageIconTrait)
      {
         super();
         this._trait = param1;
         addEventListener(Event.ADDED_TO_STAGE,this.handleAdded);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemoved);
         this.load();
      }
      
      private function load() : void
      {
         ResourceManager.fileCollection.load("dmgBuffs",this.onFileLoaded);
      }
      
      private function onFileLoaded(param1:SWFFinisher) : void
      {
         MovieClipUtils.removeDisplayObject(this._mc);
         this._mc = param1.getEmbeddedMovieClip(MAPPING[this._trait.type]);
         addChild(this._mc);
         this.update();
      }
      
      private function handleRemoved(param1:Event) : void
      {
         this._trait.level.changed.remove(this.update);
         this._trait.type.changed.remove(this.load);
      }
      
      private function handleAdded(param1:Event) : void
      {
         this._trait.level.changed.add(this.update);
         this._trait.type.changed.add(this.load);
      }
      
      private function update() : void
      {
         if(this._mc)
         {
            this.updateLevel(this._trait.level.value);
            sizeChanged.dispatch();
         }
      }
      
      private function updateLevel(param1:int) : void
      {
         var _loc2_:Rectangle = null;
         this._mc.gotoAndStop(Math.min(param1,this._mc.framesLoaded) as int);
         _loc2_ = this._mc.getBounds(this._mc);
         this._mc.x = -_loc2_.x;
         this._mc.y = -_loc2_.y;
         TweenMax.to(this._mc,1,{
            "glowFilter":{
               "color":16777215,
               "blurX":3,
               "blurY":3,
               "strength":2,
               "alpha":1
            },
            "onComplete":this.removeGlow
         });
      }
      
      private function removeGlow() : void
      {
         TweenMax.to(this._mc,1,{"glowFilter":{
            "color":16777215,
            "blurX":3,
            "blurY":3,
            "strength":2,
            "alpha":0,
            "remove":true
         }});
      }
   }
}

