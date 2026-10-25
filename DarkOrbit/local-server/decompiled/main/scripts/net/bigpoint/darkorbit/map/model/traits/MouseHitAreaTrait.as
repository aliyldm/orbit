package net.bigpoint.darkorbit.map.model.traits
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.bigpoint.utils.ui.tooltip.StandaloneToolTipHook;
   import net.bigpoint.darkorbit.map.IMapView;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class MouseHitAreaTrait extends EntityTraitBase
   {
      
      public var clickRadius:int = 0;
      
      public var clickPriority:int = 0;
      
      public const clickScreenOffset:PointLite = new PointLite(0,0);
      
      public const enabled:BindableBoolean = new BindableBoolean(true);
      
      public const clicked:ISignal = new Signal();
      
      public const rolledOver:ISignal = new Signal();
      
      public const rolledOut:ISignal = new Signal();
      
      public const disabledSignal:ISignal = new Signal();
      
      public var toolTip:String;
      
      protected var _lockTrigger:Boolean = true;
      
      private var _pivot:BindablePointLite;
      
      private const _screenPosition:PointLite = new PointLite();
      
      public function MouseHitAreaTrait(param1:int, param2:int = 0, param3:int = 0, param4:int = 0, param5:BindablePointLite = null)
      {
         super();
         this.clickRadius = param1;
         this.clickPriority = param2;
         this.clickScreenOffset.x = param3;
         this.clickScreenOffset.y = param4;
         this._pivot = param5 || new BindablePointLite();
         this.enabled.changed.add(this.handleEnabledChanged);
      }
      
      public function getScreenPosition(param1:IMapView) : PointLite
      {
         param1.game2screen(owner.x + this._pivot.x,owner.y + this._pivot.y,owner.z + this._pivot.z,this._screenPosition);
         this._screenPosition.incrementBy(this.clickScreenOffset);
         return this._screenPosition;
      }
      
      public function mouseClick() : void
      {
         if(this.enabled.value)
         {
            this.clicked.dispatch();
         }
      }
      
      public function mouseOver() : void
      {
         if(this.enabled.value)
         {
            this.rolledOver.dispatch();
            if(this.toolTip)
            {
               StandaloneToolTipHook.getInstance().show(this.toolTip);
            }
         }
      }
      
      public function mouseOut() : void
      {
         if(this.enabled.value)
         {
            this.rolledOut.dispatch();
         }
         StandaloneToolTipHook.getInstance().hide();
      }
      
      private function handleEnabledChanged() : void
      {
         if(this.enabled.value == false)
         {
            this.disabledSignal.dispatch();
         }
      }
      
      public function get isLockTrigger() : Boolean
      {
         return this._lockTrigger;
      }
   }
}

