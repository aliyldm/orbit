package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HallOfFameDataListCommand implements IModule
   {
      
      private static var _instance:HallOfFameDataListCommand;
      
      public var dataList:Vector.<HallOfFameDataCommand>;
      
      public var type:int = 0;
      
      public var pages:Vector.<HallOfFamePages>;
      
      public var myList:Vector.<HallOfFameDataCommand>;
      
      public function HallOfFameDataListCommand(param1:int = 0, param2:Vector.<HallOfFameDataCommand> = null, param3:Vector.<HallOfFameDataCommand> = null, param4:Vector.<HallOfFamePages> = null)
      {
         super();
         if(param2 == null)
         {
            this.dataList = new Vector.<HallOfFameDataCommand>();
         }
         else
         {
            this.dataList = param2;
         }
         this.type = param1;
         if(param4 == null)
         {
            this.pages = new Vector.<HallOfFamePages>();
         }
         else
         {
            this.pages = param4;
         }
         if(param3 == null)
         {
            this.myList = new Vector.<HallOfFameDataCommand>();
         }
         else
         {
            this.myList = param3;
         }
      }
      
      public static function get instance() : HallOfFameDataListCommand
      {
         return _instance || (_instance = new HallOfFameDataListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24452;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HallOfFameDataCommand = null;
         var _loc5_:HallOfFamePages = null;
         var _loc6_:HallOfFameDataCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.dataList.length > 0)
         {
            this.dataList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HallOfFameDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.dataList.push(_loc4_);
            _loc2_++;
         }
         this.type = param1.readShort();
         while(this.pages.length > 0)
         {
            this.pages.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = HallOfFamePages(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.pages.push(_loc5_);
            _loc2_++;
         }
         while(this.myList.length > 0)
         {
            this.myList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = HallOfFameDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.myList.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HallOfFameDataCommand = null;
         var _loc3_:HallOfFamePages = null;
         var _loc4_:HallOfFameDataCommand = null;
         param1.writeShort(24452);
         param1.writeByte(this.dataList.length);
         for each(_loc2_ in this.dataList)
         {
            _loc2_.write(param1);
         }
         param1.writeShort(this.type);
         param1.writeByte(this.pages.length);
         for each(_loc3_ in this.pages)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.myList.length);
         for each(_loc4_ in this.myList)
         {
            _loc4_.write(param1);
         }
      }
   }
}

