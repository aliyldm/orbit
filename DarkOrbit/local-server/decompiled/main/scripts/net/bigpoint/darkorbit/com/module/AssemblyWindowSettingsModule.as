package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AssemblyWindowSettingsModule implements IModule
   {
      
      private static var _instance:AssemblyWindowSettingsModule;
      
      public static const FILTERTYPE_ASSEMBLY:int = 0;
      
      public static const FILTERTYPE_UPGRADE:int = 1;
      
      public static const FILTERTYPE_DISASSEMBLY:int = 2;
      
      public static const FILTERTYPE__MAX:int = 3;
      
      public var filterType:int = 0;
      
      public var assemblyItemFilters:Vector.<String>;
      
      public function AssemblyWindowSettingsModule(param1:Vector.<String> = null, param2:int = 0)
      {
         super();
         this.filterType = param2;
         if(param1 == null)
         {
            this.assemblyItemFilters = new Vector.<String>();
         }
         else
         {
            this.assemblyItemFilters = param1;
         }
      }
      
      public static function get instance() : AssemblyWindowSettingsModule
      {
         return _instance || (_instance = new AssemblyWindowSettingsModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18373;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.filterType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.assemblyItemFilters.length > 0)
         {
            this.assemblyItemFilters.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.assemblyItemFilters.push(param1.readUTF());
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:String = null;
         param1.writeShort(-18373);
         param1.writeShort(this.filterType);
         param1.writeByte(this.assemblyItemFilters.length);
         for each(_loc2_ in this.assemblyItemFilters)
         {
            param1.writeUTF(_loc2_);
         }
      }
   }
}

