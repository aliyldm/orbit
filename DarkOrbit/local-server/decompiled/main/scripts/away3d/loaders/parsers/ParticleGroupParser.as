package away3d.loaders.parsers
{
   import away3d.animators.data.ParticleGroupEventProperty;
   import away3d.animators.data.ParticleInstanceProperty;
   import away3d.arcane;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.particleSubParsers.values.property.InstancePropertySubParser;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class ParticleGroupParser extends CompositeParserBase
   {
      
      private var _particleGroup:ParticleGroup;
      
      private var _animationParsers:Vector.<ParticleAnimationParser>;
      
      private var _instancePropertyParsers:Vector.<InstancePropertySubParser>;
      
      private var _customParameters:Object;
      
      private var _particleEvents:Vector.<ParticleGroupEventProperty>;
      
      public function ParticleGroupParser()
      {
         super();
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "awp";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         var serializedData:Object = null;
         var data:* = param1;
         try
         {
            serializedData = JSON.parse(data);
         }
         catch(e:Error)
         {
            return false;
         }
         return serializedData.hasOwnProperty("animationDatas");
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Array = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:InstancePropertySubParser = null;
         var _loc8_:ParticleAnimationParser = null;
         if(_isFirstParsing)
         {
            this._customParameters = _data.customParameters;
            _loc1_ = _data.animationDatas;
            this._animationParsers = new Vector.<ParticleAnimationParser>(_loc1_.length,true);
            this._instancePropertyParsers = new Vector.<InstancePropertySubParser>(_loc1_.length,true);
            _loc2_ = _data.particleEvents as Array;
            if(_loc2_)
            {
               this._particleEvents = new Vector.<ParticleGroupEventProperty>();
               for each(_loc4_ in _loc2_)
               {
                  this._particleEvents.push(new ParticleGroupEventProperty(_loc4_.occurTime,_loc4_.name));
               }
            }
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc5_ = _loc1_[_loc3_];
               _loc6_ = _loc5_.property;
               if(_loc6_)
               {
                  _loc7_ = new InstancePropertySubParser(null);
                  addSubParser(_loc7_);
                  _loc7_.parseAsync(_loc6_.data);
                  this._instancePropertyParsers[_loc3_] = _loc7_;
               }
               if(_loc5_.embed)
               {
                  _loc8_ = new ParticleAnimationParser();
                  addSubParser(_loc8_);
                  _loc8_.parseAsync(_loc5_.data);
                  this._animationParsers[_loc3_] = _loc8_;
               }
               else
               {
                  addDependency(_loc3_.toString(),new URLRequest(_loc5_.url),true);
               }
               _loc3_++;
            }
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.generateGroup();
            finalizeAsset(this._particleGroup);
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         var _loc2_:int = int(param1.id);
         var _loc3_:ParticleAnimationParser = new ParticleAnimationParser();
         addSubParser(_loc3_);
         _loc3_.parseAsync(param1.data);
         this._animationParsers[_loc2_] = _loc3_;
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
         dieWithError("resolveDependencyFailure");
      }
      
      private function generateGroup() : void
      {
         var _loc4_:int = 0;
         var _loc5_:ParticleAnimationParser = null;
         var _loc1_:int = int(this._animationParsers.length);
         var _loc2_:Vector.<Mesh> = new Vector.<Mesh>();
         var _loc3_:Vector.<ParticleInstanceProperty> = new Vector.<ParticleInstanceProperty>(_loc1_,true);
         while(_loc4_ < this._animationParsers.length)
         {
            _loc5_ = this._animationParsers[_loc4_];
            if(this._instancePropertyParsers[_loc4_])
            {
               _loc3_[_loc4_] = ParticleInstanceProperty(this._instancePropertyParsers[_loc4_].setter.generateOneValue());
            }
            _loc2_.push(_loc5_.particleMesh);
            _loc4_++;
         }
         this._particleGroup = new ParticleGroup(_loc2_,_loc3_,this._customParameters,this._particleEvents);
      }
      
      public function get particleGroup() : ParticleGroup
      {
         return this._particleGroup;
      }
   }
}

