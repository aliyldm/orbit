package net.bigpoint.darkorbit.map.model.ship.minimap
{
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.minimap.traits.AbstractMiniMapTrait;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class HeroMiniMapTrait extends AbstractMiniMapTrait
   {
      
      public var destinationMarkerVisible:Boolean = true;
      
      private var _destinationIcon:Bitmap = ResourceManager.getBitmap("minimap","mapIcon_finish");
      
      private var _triangleShape:Shape;
      
      private var minimapRevealEffect:MovieClip = null;
      
      private var _minimapRevealEffectWidth:Number;
      
      public function HeroMiniMapTrait()
      {
         super(new Sprite(),false,false,1);
      }
      
      override protected function update() : void
      {
         var triangleSize:int = 0;
         super.update();
         this.shape.graphics.clear();
         if(this.destinationMarkerVisible && this.hero.moveTrait.destination != null)
         {
            this._destinationIcon.x = this.hero.moveTrait.destination.x * _scale - this._destinationIcon.width / 2;
            this._destinationIcon.y = this.hero.moveTrait.destination.y * _scale - this._destinationIcon.height / 2;
            this.shape.addChild(this._destinationIcon);
            this.shape.graphics.lineStyle(1,6649302,1,true);
            this.shape.graphics.moveTo(this.hero.position.x * _scale,this.hero.position.y * _scale);
            this.shape.graphics.lineTo(this.hero.moveTrait.destination.x * _scale,this.hero.moveTrait.destination.y * _scale);
         }
         else if(this._destinationIcon.parent)
         {
            this._destinationIcon.parent.removeChild(this._destinationIcon);
         }
         with(this.shape.graphics)
         {
            lineStyle(0.5,15658734,90 / 256);
            moveTo(hero.position.x * _scale - 1000,hero.position.y * _scale);
            lineTo(hero.position.x * _scale + 1000,hero.position.y * _scale);
            moveTo(hero.position.x * _scale,hero.position.y * _scale - 1000);
            lineTo(hero.position.x * _scale,hero.position.y * _scale + 1000);
         }
         if(!this._triangleShape)
         {
            this._triangleShape = new Shape();
            triangleSize = 11;
            this._triangleShape.graphics.beginFill(16777215,1);
            this._triangleShape.graphics.moveTo(0,0.5 * triangleSize);
            this._triangleShape.graphics.lineTo(0.25 * triangleSize,-0.5 * triangleSize);
            this._triangleShape.graphics.lineTo(-0.25 * triangleSize,-0.5 * triangleSize);
            this._triangleShape.graphics.lineTo(0,0.5 * triangleSize);
            this._triangleShape.graphics.endFill();
            this.shape.addChild(this._triangleShape);
         }
         this._triangleShape.x = this.hero.position.x * _scale;
         this._triangleShape.y = this.hero.position.y * _scale;
         this._triangleShape.visible = false;
         if(owner.position.x * _scale < 0.5 * this._triangleShape.width)
         {
            this._triangleShape.x = 0.5 * this._triangleShape.width;
            this._triangleShape.rotation = 90;
            this._triangleShape.visible = true;
         }
         if(owner.position.x * _scale > _miniMapWidth - 0.5 * this._triangleShape.width)
         {
            this._triangleShape.x = _miniMapWidth - 0.5 * this._triangleShape.width;
            this._triangleShape.rotation = 270;
            this._triangleShape.visible = true;
         }
         if(owner.position.y * _scale < 0.5 * this._triangleShape.height)
         {
            this._triangleShape.y = 0.5 * this._triangleShape.height;
            this._triangleShape.rotation = 180;
            this._triangleShape.visible = true;
         }
         if(owner.position.y * _scale > _miniMapHeight - 0.5 * this._triangleShape.height)
         {
            this._triangleShape.y = _miniMapHeight - 0.5 * this._triangleShape.height;
            this._triangleShape.rotation = 0;
            this._triangleShape.visible = true;
         }
         this.updateRevealEffect();
      }
      
      private function get hero() : Ship
      {
         return owner as Ship;
      }
      
      private function get shape() : Sprite
      {
         return _icon as Sprite;
      }
      
      public function addDoubleMinimapRevealEffect(param1:Boolean = false) : void
      {
         if(this.minimapRevealEffect == null)
         {
            this.minimapRevealEffect = ResourceManager.getMovieClip("minimap","doubleMinimapReveal");
            this._minimapRevealEffectWidth = this.minimapRevealEffect.width;
         }
         this.shape.addChild(this.minimapRevealEffect);
         this.updateRevealEffect();
         this.minimapRevealEffect.alpha = 0;
         TweenLite.to(this.minimapRevealEffect,param1 ? 0 : 1,{"alpha":0.3});
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SPEARHEAD_DOUBLE_MINIMAP_REVEAL,false,false,this.hero.x,this.hero.y);
      }
      
      private function updateRevealEffect() : void
      {
         if(Boolean(this.minimapRevealEffect) && Boolean(this.minimapRevealEffect.parent))
         {
            TweenLite.killTweensOf(this.minimapRevealEffect);
            this.minimapRevealEffect.alpha = 0.3;
            this.minimapRevealEffect.x = this.hero.x * _scale;
            this.minimapRevealEffect.y = this.hero.y * _scale;
            this.minimapRevealEffect.scaleX = this.minimapRevealEffect.scaleY = _scale * 1700 / (0.5 * this._minimapRevealEffectWidth) * 2;
         }
      }
      
      public function removeDoubleMinimapRevealEffect() : void
      {
         if(this.minimapRevealEffect != null)
         {
            TweenLite.to(this.minimapRevealEffect,1,{
               "alpha":0,
               "scaleX":0,
               "scaleY":0,
               "onComplete":this.minimapRevealEffect.parent.removeChild,
               "onCompleteParams":[this.minimapRevealEffect]
            });
            this.minimapRevealEffect = null;
         }
      }
   }
}

