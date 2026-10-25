package away3d.materials.compilation
{
   import flash.utils.Dictionary;
   
   internal class RegisterPool
   {
      
      private static const _regPool:Dictionary = new Dictionary();
      
      private static const _regCompsPool:Dictionary = new Dictionary();
      
      private var _vectorRegisters:Vector.<ShaderRegisterElement>;
      
      private var _registerComponents:Array;
      
      private var _regName:String;
      
      private var _usedSingleCount:Vector.<Vector.<uint>>;
      
      private var _usedVectorCount:Vector.<uint>;
      
      private var _regCount:int;
      
      private var _persistent:Boolean;
      
      public function RegisterPool(param1:String, param2:int, param3:Boolean = true)
      {
         super();
         this._regName = param1;
         this._regCount = param2;
         this._persistent = param3;
         this.initRegisters(param1,param2);
      }
      
      private static function _initPool(param1:String, param2:int) : String
      {
         var _loc7_:int = 0;
         var _loc3_:String = param1 + param2;
         if(_regPool[_loc3_] != undefined)
         {
            return _loc3_;
         }
         var _loc4_:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(param2,true);
         _regPool[_loc3_] = _loc4_;
         var _loc5_:Array = [[],[],[],[]];
         _regCompsPool[_loc3_] = _loc5_;
         var _loc6_:int = 0;
         while(_loc6_ < param2)
         {
            _loc4_[_loc6_] = new ShaderRegisterElement(param1,_loc6_);
            _loc7_ = 0;
            while(_loc7_ < 4)
            {
               _loc5_[_loc7_][_loc6_] = new ShaderRegisterElement(param1,_loc6_,_loc7_);
               _loc7_++;
            }
            _loc6_++;
         }
         return _loc3_;
      }
      
      public function requestFreeVectorReg() : ShaderRegisterElement
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._regCount)
         {
            if(!this.isRegisterUsed(_loc1_))
            {
               if(this._persistent)
               {
                  ++this._usedVectorCount[_loc1_];
               }
               return this._vectorRegisters[_loc1_];
            }
            _loc1_++;
         }
         throw new Error("Register overflow!");
      }
      
      public function requestFreeRegComponent() : ShaderRegisterElement
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         for(; _loc1_ < this._regCount; _loc1_++)
         {
            if(this._usedVectorCount[_loc1_] <= 0)
            {
               _loc2_ = 0;
               while(_loc2_ < 4)
               {
                  if(this._usedSingleCount[_loc2_][_loc1_] == 0)
                  {
                     if(this._persistent)
                     {
                        ++this._usedSingleCount[_loc2_][_loc1_];
                     }
                     return this._registerComponents[_loc2_][_loc1_];
                     break;
                  }
                  _loc2_++;
               }
            }
         }
         throw new Error("Register overflow!");
      }
      
      public function addUsage(param1:ShaderRegisterElement, param2:int) : void
      {
         if(param1._component > -1)
         {
            this._usedSingleCount[param1._component][param1.index] += param2;
         }
         else
         {
            this._usedVectorCount[param1.index] += param2;
         }
      }
      
      public function removeUsage(param1:ShaderRegisterElement) : void
      {
         if(param1._component > -1)
         {
            if(--this._usedSingleCount[param1._component][param1.index] < 0)
            {
               throw new Error("More usages removed than exist!");
            }
         }
         else if(--this._usedVectorCount[param1.index] < 0)
         {
            throw new Error("More usages removed than exist!");
         }
      }
      
      public function dispose() : void
      {
         this._vectorRegisters = null;
         this._registerComponents = null;
         this._usedSingleCount = null;
         this._usedVectorCount = null;
      }
      
      public function hasRegisteredRegs() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._regCount)
         {
            if(this.isRegisterUsed(_loc1_))
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function initRegisters(param1:String, param2:int) : void
      {
         var _loc3_:String = RegisterPool._initPool(param1,param2);
         this._vectorRegisters = RegisterPool._regPool[_loc3_];
         this._registerComponents = RegisterPool._regCompsPool[_loc3_];
         this._usedVectorCount = new Vector.<uint>(param2,true);
         this._usedSingleCount = new Vector.<Vector.<uint>>(4,true);
         this._usedSingleCount[0] = new Vector.<uint>(param2,true);
         this._usedSingleCount[1] = new Vector.<uint>(param2,true);
         this._usedSingleCount[2] = new Vector.<uint>(param2,true);
         this._usedSingleCount[3] = new Vector.<uint>(param2,true);
      }
      
      private function isRegisterUsed(param1:int) : Boolean
      {
         if(this._usedVectorCount[param1] > 0)
         {
            return true;
         }
         var _loc2_:int = 0;
         while(_loc2_ < 4)
         {
            if(this._usedSingleCount[_loc2_][param1] > 0)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
   }
}

