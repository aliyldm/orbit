package net.bigpoint.darkorbit.map.view3D.settings
{
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightBase;
   import away3d.lights.PointLight;
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableNumber;
   import com.bigpoint.utils.bindables.BindableUint;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.view3D.utils.ExtMath;
   
   public class LightSettings extends AbstractSettings
   {
      
      public const visible:BindableBoolean = new BindableBoolean(true);
      
      public const color:BindableUint = new BindableUint(16777215,0,16777215);
      
      public const diffuse:BindableNumber = new BindableNumber(1,0,1);
      
      public const specular:BindableNumber = new BindableNumber(1,0);
      
      public const ambientColor:BindableUint = new BindableUint(16777215,0,16777215);
      
      public const ambient:BindableNumber = new BindableNumber(0,0,1);
      
      public const radius:BindableNumber = new BindableNumber(0,0);
      
      public const fallOff:BindableNumber = new BindableNumber(100,0);
      
      public const directionTilt:BindableNumber = new BindableNumber(45,0,180);
      
      public const directionPan:BindableNumber = new BindableNumber(45);
      
      public const animateSpeed:BindableNumber = new BindableNumber(0);
      
      private var _isPointLight:Boolean;
      
      public function LightSettings(param1:Boolean, param2:Boolean, param3:uint, param4:Number, param5:Number, param6:uint, param7:Number, param8:Number, param9:Number, param10:Number = 0, param11:Number = 0, param12:Number = 0)
      {
         super();
         this._isPointLight = param1;
         this.visible.value = param2;
         this.color.value = param3;
         this.diffuse.value = param4;
         this.specular.value = param5;
         this.ambientColor.value = param6;
         this.ambient.value = param7;
         this.radius.value = param8;
         this.fallOff.value = param9;
         this.directionTilt.value = param10;
         this.directionPan.value = param11;
         this.animateSpeed.value = 0;
      }
      
      public function save(param1:Object) : void
      {
         param1.version = 1;
         param1.visible = this.visible.value;
         param1.color = this.color.value;
         param1.diffuse = this.diffuse.value;
         param1.specular = this.specular.value;
         param1.ambientColor = this.ambientColor.value;
         param1.ambient = this.ambient.value;
         param1.radius = this.radius.value;
         param1.fallOff = this.fallOff.value;
         param1.directionTilt = this.directionTilt.value;
         param1.directionPan = this.directionPan.value;
         param1.animateSpeed = this.animateSpeed.value;
      }
      
      public function restore(param1:Object) : void
      {
         var _loc2_:int = int(param1.version);
         if(_loc2_ == 1)
         {
            this.visible.value = parseBoolean(param1.visible,true);
            this.color.value = parseUint(param1.color,16777215);
            this.diffuse.value = parseNumber(param1.diffuse,1);
            this.specular.value = parseNumber(param1.specular,1);
            this.ambientColor.value = parseUint(param1.ambientColor,16777215);
            this.ambient.value = parseNumber(param1.ambient,0);
            this.radius.value = parseNumber(param1.radius,0);
            this.fallOff.value = parseNumber(param1.fallOff,0);
            this.directionTilt.value = parseNumber(param1.directionTilt,this.directionTilt.value);
            this.directionPan.value = parseNumber(param1.directionPan,this.directionPan.value);
            this.animateSpeed.value = parseNumber(param1.animateSpeed,this.animateSpeed.value);
         }
      }
      
      public function copyFrom(param1:LightSettings) : void
      {
         this.visible.value = param1.visible.value;
         this.color.value = param1.color.value;
         this.diffuse.value = param1.diffuse.value;
         this.specular.value = param1.specular.value;
         this.ambientColor.value = param1.ambientColor.value;
         this.ambient.value = param1.ambient.value;
         this.radius.value = param1.radius.value;
         this.fallOff.value = param1.fallOff.value;
         this.directionTilt.value = param1.directionTilt.value;
         this.directionPan.value = param1.directionPan.value;
         this.animateSpeed.value = param1.animateSpeed.value;
      }
      
      public function get isPointLight() : Boolean
      {
         return this._isPointLight;
      }
      
      public function clone() : LightSettings
      {
         return new LightSettings(this._isPointLight,this.visible.value,this.color.value,this.diffuse.value,this.specular.value,this.ambientColor.value,this.ambient.value,this.radius.value,this.fallOff.value,this.directionTilt.value,this.directionPan.value,this.animateSpeed.value);
      }
      
      public function apply(param1:LightBase) : void
      {
         var _loc2_:Vector3D = null;
         param1.visible = this.visible.value;
         param1.color = this.color.value;
         param1.diffuse = this.diffuse.value;
         param1.specular = this.specular.value;
         param1.ambientColor = this.ambientColor.value;
         param1.ambient = this.ambient.value;
         if(param1 is PointLight)
         {
            PointLight(param1).radius = this.radius.value;
            PointLight(param1).fallOff = this.fallOff.value;
         }
         else
         {
            _loc2_ = DirectionalLight(param1).direction;
            ExtMath.tiltPan2Vector(this.directionTilt.value,this.directionPan.value,-1,_loc2_);
            DirectionalLight(param1).direction = _loc2_;
         }
      }
   }
}

