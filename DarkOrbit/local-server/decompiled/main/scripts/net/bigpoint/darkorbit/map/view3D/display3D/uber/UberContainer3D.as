package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.containers.ObjectContainer3D;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import org.osflash.signals.Signal;
   
   public class UberContainer3D extends ObjectContainer3D implements IDisposable
   {
      
      public const ready:Signal = new Signal();
      
      protected var _descriptor:XML;
      
      private var _state:BindableString;
      
      private var _qualitySettings:BindableBoolean;
      
      private var _includeIn:Vector.<String>;
      
      public function UberContainer3D(param1:XML, param2:BindableString = null, param3:BindableBoolean = null)
      {
         super();
         this._descriptor = param1;
         if(this._descriptor)
         {
            if(this._descriptor.attribute("includeIn").length() > 0)
            {
               this._state = param2;
               this._state.changed.add(this.reload);
               this._includeIn = Vector.<String>(String(this._descriptor.@includeIn).split(","));
            }
            this._qualitySettings = Settings3D.getEffectsQualityFromLookup(this._descriptor.attribute("quality_settings")) || param3;
            if(this._qualitySettings)
            {
               this._qualitySettings.changed.add(this.reload);
            }
            this.reload(true);
         }
         else
         {
            setTimeout(this.ready.dispatch,1);
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.unloadView();
         if(this._qualitySettings)
         {
            this._qualitySettings.changed.remove(this.reload);
            this._qualitySettings = null;
         }
         if(this._state)
         {
            this._state.changed.remove(this.reload);
         }
      }
      
      protected function loadView() : void
      {
      }
      
      protected function unloadView() : void
      {
      }
      
      protected function reload(param1:Boolean = false) : void
      {
         if((this._includeIn == null || this._includeIn.indexOf(this._state.value) != -1) && (this._qualitySettings == null || this._qualitySettings.value))
         {
            visible = true;
            this.loadView();
         }
         else
         {
            this.unloadView();
            visible = false;
            if(param1)
            {
               setTimeout(this.ready.dispatch,1);
            }
         }
      }
   }
}

