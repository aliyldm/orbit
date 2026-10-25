package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.events.ShadingMethodEvent;
   import flash.events.EventDispatcher;
   
   use namespace arcane;
   
   public class ShaderMethodSetup extends EventDispatcher
   {
      
      arcane var _colorTransformMethod:ColorTransformMethod;
      
      arcane var _colorTransformMethodVO:MethodVO;
      
      arcane var _normalMethod:BasicNormalMethod;
      
      arcane var _normalMethodVO:MethodVO;
      
      arcane var _ambientMethod:BasicAmbientMethod;
      
      arcane var _ambientMethodVO:MethodVO;
      
      arcane var _shadowMethod:ShadowMapMethodBase;
      
      arcane var _shadowMethodVO:MethodVO;
      
      arcane var _diffuseMethod:BasicDiffuseMethod;
      
      arcane var _diffuseMethodVO:MethodVO;
      
      arcane var _specularMethod:BasicSpecularMethod;
      
      arcane var _specularMethodVO:MethodVO;
      
      arcane var _methods:Vector.<MethodVOSet>;
      
      public function ShaderMethodSetup()
      {
         super();
         this._methods = new Vector.<MethodVOSet>();
         this._normalMethod = new BasicNormalMethod();
         this._ambientMethod = new BasicAmbientMethod();
         this._diffuseMethod = new BasicDiffuseMethod();
         this._specularMethod = new BasicSpecularMethod();
         this._normalMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._diffuseMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._ambientMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this._normalMethodVO = this._normalMethod.createMethodVO();
         this._ambientMethodVO = this._ambientMethod.createMethodVO();
         this._diffuseMethodVO = this._diffuseMethod.createMethodVO();
         this._specularMethodVO = this._specularMethod.createMethodVO();
      }
      
      private function onShaderInvalidated(param1:ShadingMethodEvent) : void
      {
         this.invalidateShaderProgram();
      }
      
      private function invalidateShaderProgram() : void
      {
         dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
      }
      
      public function get normalMethod() : BasicNormalMethod
      {
         return this._normalMethod;
      }
      
      public function set normalMethod(param1:BasicNormalMethod) : void
      {
         if(this._normalMethod)
         {
            this._normalMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
         if(param1)
         {
            if(this._normalMethod)
            {
               param1.copyFrom(this._normalMethod);
            }
            this._normalMethodVO = param1.createMethodVO();
            param1.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
         this._normalMethod = param1;
         if(param1)
         {
            this.invalidateShaderProgram();
         }
      }
      
      public function get ambientMethod() : BasicAmbientMethod
      {
         return this._ambientMethod;
      }
      
      public function set ambientMethod(param1:BasicAmbientMethod) : void
      {
         if(this._ambientMethod)
         {
            this._ambientMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
         if(param1)
         {
            if(this._ambientMethod)
            {
               param1.copyFrom(this._ambientMethod);
            }
            param1.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this._ambientMethodVO = param1.createMethodVO();
         }
         this._ambientMethod = param1;
         if(param1)
         {
            this.invalidateShaderProgram();
         }
      }
      
      public function get shadowMethod() : ShadowMapMethodBase
      {
         return this._shadowMethod;
      }
      
      public function set shadowMethod(param1:ShadowMapMethodBase) : void
      {
         if(this._shadowMethod)
         {
            this._shadowMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
         this._shadowMethod = param1;
         if(this._shadowMethod)
         {
            this._shadowMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this._shadowMethodVO = this._shadowMethod.createMethodVO();
         }
         else
         {
            this._shadowMethodVO = null;
         }
         this.invalidateShaderProgram();
      }
      
      public function get diffuseMethod() : BasicDiffuseMethod
      {
         return this._diffuseMethod;
      }
      
      public function set diffuseMethod(param1:BasicDiffuseMethod) : void
      {
         if(this._diffuseMethod)
         {
            this._diffuseMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
         if(param1)
         {
            if(this._diffuseMethod)
            {
               param1.copyFrom(this._diffuseMethod);
            }
            param1.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this._diffuseMethodVO = param1.createMethodVO();
         }
         this._diffuseMethod = param1;
         if(param1)
         {
            this.invalidateShaderProgram();
         }
      }
      
      public function get specularMethod() : BasicSpecularMethod
      {
         return this._specularMethod;
      }
      
      public function set specularMethod(param1:BasicSpecularMethod) : void
      {
         if(this._specularMethod)
         {
            this._specularMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            if(param1)
            {
               param1.copyFrom(this._specularMethod);
            }
         }
         this._specularMethod = param1;
         if(this._specularMethod)
         {
            this._specularMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this._specularMethodVO = this._specularMethod.createMethodVO();
         }
         else
         {
            this._specularMethodVO = null;
         }
         this.invalidateShaderProgram();
      }
      
      arcane function get colorTransformMethod() : ColorTransformMethod
      {
         return this._colorTransformMethod;
      }
      
      arcane function set colorTransformMethod(param1:ColorTransformMethod) : void
      {
         if(this._colorTransformMethod == param1)
         {
            return;
         }
         if(this._colorTransformMethod)
         {
            this._colorTransformMethod.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
         if(!this._colorTransformMethod || !param1)
         {
            this.invalidateShaderProgram();
         }
         this._colorTransformMethod = param1;
         if(this._colorTransformMethod)
         {
            this._colorTransformMethod.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this._colorTransformMethodVO = this._colorTransformMethod.createMethodVO();
         }
         else
         {
            this._colorTransformMethodVO = null;
         }
      }
      
      public function dispose() : void
      {
         this.clearListeners(this._normalMethod);
         this.clearListeners(this._diffuseMethod);
         this.clearListeners(this._shadowMethod);
         this.clearListeners(this._ambientMethod);
         this.clearListeners(this._specularMethod);
         var _loc1_:int = 0;
         while(_loc1_ < this._methods.length)
         {
            this.clearListeners(this._methods[_loc1_].method);
            _loc1_++;
         }
         this._methods = null;
      }
      
      private function clearListeners(param1:ShadingMethodBase) : void
      {
         if(param1)
         {
            param1.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         }
      }
      
      public function addMethod(param1:EffectMethodBase) : void
      {
         this._methods.push(new MethodVOSet(param1));
         param1.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this.invalidateShaderProgram();
      }
      
      public function hasMethod(param1:EffectMethodBase) : Boolean
      {
         return this.getMethodSetForMethod(param1) != null;
      }
      
      public function addMethodAt(param1:EffectMethodBase, param2:int) : void
      {
         this._methods.splice(param2,0,new MethodVOSet(param1));
         param1.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
         this.invalidateShaderProgram();
      }
      
      public function getMethodAt(param1:int) : EffectMethodBase
      {
         if(param1 > this._methods.length - 1)
         {
            return null;
         }
         return this._methods[param1].method;
      }
      
      public function get numMethods() : int
      {
         return this._methods.length;
      }
      
      public function removeMethod(param1:EffectMethodBase) : void
      {
         var _loc3_:int = 0;
         var _loc2_:MethodVOSet = this.getMethodSetForMethod(param1);
         if(_loc2_ != null)
         {
            _loc3_ = this._methods.indexOf(_loc2_);
            this._methods.splice(_loc3_,1);
            param1.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this.invalidateShaderProgram();
         }
      }
      
      private function getMethodSetForMethod(param1:EffectMethodBase) : MethodVOSet
      {
         var _loc2_:int = int(this._methods.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._methods[_loc3_].method == param1)
            {
               return this._methods[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
   }
}

