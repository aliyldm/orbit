package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetGearSelectCommand implements IModule
   {
      
      private static var _instance:PetGearSelectCommand;
      
      public var gearType:PetGearTypeModule;
      
      public var optionalParams:Vector.<int>;
      
      public function PetGearSelectCommand(param1:PetGearTypeModule = null, param2:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.gearType = new PetGearTypeModule();
         }
         else
         {
            this.gearType = param1;
         }
         if(param2 == null)
         {
            this.optionalParams = new Vector.<int>();
         }
         else
         {
            this.optionalParams = param2;
         }
      }
      
      public static function get instance() : PetGearSelectCommand
      {
         return _instance || (_instance = new PetGearSelectCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 236;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.gearType = PetGearTypeModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.gearType)
         {
            this.gearType.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.optionalParams.length > 0)
         {
            this.optionalParams.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 3 % 32 | _loc4_ << 32 - 3 % 32;
            this.optionalParams.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(236);
         if(null != this.gearType)
         {
            this.gearType.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.optionalParams.length);
         for each(_loc2_ in this.optionalParams)
         {
            param1.writeInt(_loc2_ << 3 % 32 | _loc2_ >>> 32 - 3 % 32);
         }
      }
   }
}

