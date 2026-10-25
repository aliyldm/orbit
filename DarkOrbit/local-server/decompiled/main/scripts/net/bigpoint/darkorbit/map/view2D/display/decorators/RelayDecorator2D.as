package net.bigpoint.darkorbit.map.view2D.display.decorators
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.display.IMapUberAssetDecorator2D;
   import net.bigpoint.darkorbit.map.view2D.display.uber.UberAsset2D;
   
   public class RelayDecorator2D implements IMapUberAssetDecorator2D
   {
      
      private var _hp:HPTrait;
      
      private var _viewOwner:UberAsset2D;
      
      public function RelayDecorator2D()
      {
         super();
      }
      
      public function decorateUberAsset(param1:UberDisplayTrait, param2:UberAsset2D, param3:Object) : void
      {
         this._hp = param1.owner.getFirstTrait(HPTrait) as HPTrait;
         this._hp.changed.add(this.update);
         this._viewOwner = param2;
         this.update();
      }
      
      private function update() : void
      {
         if(this._viewOwner.getViewElement("glow"))
         {
            TweenLite.to(this._viewOwner.getViewElement("glow"),0.25,{"alpha":this._hp.hp.value / this._hp.maxHP.value});
         }
      }
   }
}

