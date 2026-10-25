package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.env.mine.Mine;
   import net.bigpoint.darkorbit.map.model.env.mine.MinePulsePattern;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class MineDecorator2D implements IMapUberAssetDecorator2D
   {
      
      private var _minePulsePattern:MinePulsePattern;
      
      private var _viewOwner:UberAsset2D;
      
      public function MineDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._viewOwner = param2;
         var _loc4_:Mine = Mine(param1.owner);
         if(_loc4_.pulseColorId > 0)
         {
            this._minePulsePattern = PatternManager.minePulsePatterns[_loc4_.pulseColorId] as MinePulsePattern;
            ResourceManager.fileCollection.load(this._minePulsePattern.resKey,this.handleResourceReady);
         }
      }
      
      private function handleResourceReady(param1:SWFFinisher) : void
      {
         var _loc2_:MovieClip = param1.getEmbeddedMovieClip("mc");
         _loc2_.scaleX = this._minePulsePattern.scale;
         _loc2_.scaleY = this._minePulsePattern.scale;
         var _loc3_:ColorTransform = new ColorTransform();
         _loc3_.color = this._minePulsePattern.color;
         _loc3_.alphaMultiplier = this._minePulsePattern.alpha;
         _loc2_.transform.colorTransform = _loc3_;
         this._viewOwner.addChild(_loc2_);
      }
   }
}

