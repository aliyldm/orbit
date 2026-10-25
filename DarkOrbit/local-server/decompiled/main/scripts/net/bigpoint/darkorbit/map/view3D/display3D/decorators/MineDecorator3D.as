package net.bigpoint.darkorbit.map.view3D.display3D.decorators
{
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.env.mine.Mine;
   import net.bigpoint.darkorbit.map.model.env.mine.MinePulsePattern;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.Particle3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.uber.UberAsset3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class MineDecorator3D implements IMapUberAssetDecorator3D, IUpdatable, IDisposable
   {
      
      private var _trait:UberDisplayTrait;
      
      private var _viewOwner:UberAsset3D;
      
      private var _pulse:Particle3D;
      
      public function MineDecorator3D()
      {
         super();
      }
      
      public function initialize(param1:UberDisplayTrait, param2:UberAsset3D, param3:Object) : void
      {
         this._trait = param1;
         this._viewOwner = param2;
      }
      
      public function decorate() : void
      {
         var _loc2_:MinePulsePattern = null;
         var _loc1_:Mine = this._trait.owner as Mine;
         if(_loc1_.pulseColorId > 0)
         {
            _loc2_ = PatternManager.minePulsePatterns[_loc1_.pulseColorId] as MinePulsePattern;
            this._pulse = new Particle3D(_loc2_.resKey3D + ".zip");
            this._pulse.ready.add(this.handlePulseReady);
         }
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._pulse)
         {
            this._pulse.updateObj(param1);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._pulse)
         {
            this._pulse.ready.remove(this.handlePulseReady);
            this._pulse.disposeView(param1);
            this._pulse = null;
         }
      }
      
      private function handlePulseReady() : void
      {
         this._viewOwner.addChild(this._pulse.view);
      }
   }
}

