package net.bigpoint.darkorbit.map.hud.effects.impl
{
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.hud.AbstractHUDElement;
   import net.bigpoint.darkorbit.map.model.effects.impl.EmoteEffect;
   import net.bigpoint.darkorbit.map.model.traits.MouseHitAreaTrait;
   
   public class EmoteEffect2D extends AbstractHUDElement
   {
      
      private static const EMOTES_LIB:String = "emotes";
      
      private var _effect:EmoteEffect;
      
      private var _container:Sprite;
      
      public function EmoteEffect2D(param1:IMapView, param2:EmoteEffect)
      {
         super(param1,param2.source.position);
         this._effect = param2;
         addChild(this._container = new Sprite());
         setTimeout(this.hide,param2.duration * 1000);
         ResourceManager.fileCollection.load(EMOTES_LIB,this.handleEmotesLoaded);
      }
      
      private function hide() : void
      {
         ResourceManager.fileCollection.removeCallbacks(EMOTES_LIB,this.handleEmotesLoaded);
         TweenMax.to(this._container,0.2,{
            "alpha":0,
            "scaleX":10,
            "scaleY":0,
            "onComplete":disposeView
         });
      }
      
      private function handleEmotesLoaded(param1:SWFFinisher) : void
      {
         var _loc4_:Number = NaN;
         var _loc2_:MouseHitAreaTrait = this._effect.source.getFirstTrait(MouseHitAreaTrait) as MouseHitAreaTrait;
         if(_loc2_)
         {
            _loc4_ = this._effect.source.id == Hero.userID ? _zoom : 1;
            this._container.y = -(_loc2_.clickRadius * _loc4_) - 80;
         }
         else
         {
            this._container.y = -100;
         }
         var _loc3_:MovieClip = param1.getEmbeddedMovieClip(this._effect.lootId);
         _loc3_.alpha = _loc3_.scaleX = _loc3_.scaleY = 0;
         this._container.addChild(_loc3_);
         TweenMax.to(_loc3_,0.2,{
            "alpha":1,
            "scaleX":1,
            "scaleY":1
         });
      }
   }
}

