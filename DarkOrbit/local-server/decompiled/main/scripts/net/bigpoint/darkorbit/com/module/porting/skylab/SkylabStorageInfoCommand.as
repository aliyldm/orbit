package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class SkylabStorageInfoCommand implements IModule
   {
      
      private static var _instance:SkylabStorageInfoCommand;
      
      public var efficiency:int = 0;
      
      public var infoOreList:Vector.<SkylabStorageOreCommand>;
      
      public function SkylabStorageInfoCommand(param1:int = 0, param2:Vector.<SkylabStorageOreCommand> = null)
      {
         super();
         this.efficiency = param1;
         if(param2 == null)
         {
            this.infoOreList = new Vector.<SkylabStorageOreCommand>();
         }
         else
         {
            this.infoOreList = param2;
         }
      }
      
      public static function get instance() : SkylabStorageInfoCommand
      {
         return _instance || (_instance = new SkylabStorageInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11573;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SkylabStorageOreCommand = null;
         this.efficiency = param1.readInt();
         this.efficiency = this.efficiency >>> 9 % 32 | this.efficiency << 32 - 9 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.infoOreList.length > 0)
         {
            this.infoOreList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SkylabStorageOreCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.infoOreList.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SkylabStorageOreCommand = null;
         param1.writeShort(11573);
         param1.writeInt(this.efficiency << 9 % 32 | this.efficiency >>> 32 - 9 % 32);
         param1.writeByte(this.infoOreList.length);
         for each(_loc2_ in this.infoOreList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

