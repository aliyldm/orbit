package net.bigpoint.darkorbit.map.view2D.effects.combat
{
   import com.greensock.TweenLite;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.ChasingShotEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   
   public class ChasingShotEffect2D extends AbstractEffect2D
   {
      
      private var _effect:ChasingShotEffect;
      
      private var _map:MapView2D;
      
      public function ChasingShotEffect2D(param1:MapView2D, param2:ChasingShotEffect)
      {
         this._map = param1;
         this._effect = param2;
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         var _loc1_:SWFFinisher = null;
         if(this.attackerShip != null && this.targetShip != null)
         {
            this._map.fxLayer.addChild(this);
            x = this.attackerShip.position.x;
            y = this.attackerShip.position.y;
            TweenLite.to(this,1,{
               "dynamicProps":{
                  "x":this.getTargetShipXPos,
                  "y":this.getTargetShipYPos
               },
               "onComplete":disposeView
            });
            _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(this._effect.assetname));
            if(_loc1_)
            {
               addChild(_loc1_.getEmbeddedMovieClip("mc"));
            }
            AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_CHASING_SHOT,false,false,this.attackerShip.position.x,this.attackerShip.position.y,true);
         }
      }
      
      private function get targetShip() : MapEntity
      {
         return this._effect.target;
      }
      
      private function get attackerShip() : MapEntity
      {
         return this._effect.attacker;
      }
      
      private function getTargetShipXPos() : Number
      {
         return this.targetShip.position.x;
      }
      
      private function getTargetShipYPos() : Number
      {
         return this.targetShip.position.y;
      }
   }
}

