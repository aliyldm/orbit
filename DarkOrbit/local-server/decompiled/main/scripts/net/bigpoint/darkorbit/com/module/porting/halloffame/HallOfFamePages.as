package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HallOfFamePages implements IModule
   {
      
      private static var _instance:HallOfFamePages;
      
      public var pageType:String = "";
      
      public var myList:Vector.<HallOfFameDataCommand>;
      
      public var dataList:Vector.<HallOfFameDataCommand>;
      
      public var type:int = 0;
      
      public var pageSize:int = 0;
      
      public var currentPage:int = 0;
      
      public var totalPage:int = 0;
      
      public function HallOfFamePages(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:Vector.<HallOfFameDataCommand> = null, param6:int = 0, param7:Vector.<HallOfFameDataCommand> = null)
      {
         super();
         this.pageType = param4;
         if(param7 == null)
         {
            this.myList = new Vector.<HallOfFameDataCommand>();
         }
         else
         {
            this.myList = param7;
         }
         if(param5 == null)
         {
            this.dataList = new Vector.<HallOfFameDataCommand>();
         }
         else
         {
            this.dataList = param5;
         }
         this.type = param6;
         this.pageSize = param3;
         this.currentPage = param2;
         this.totalPage = param1;
      }
      
      public static function get instance() : HallOfFamePages
      {
         return _instance || (_instance = new HallOfFamePages());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5955;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HallOfFameDataCommand = null;
         var _loc5_:HallOfFameDataCommand = null;
         this.pageType = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.myList.length > 0)
         {
            this.myList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HallOfFameDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.myList.push(_loc4_);
            _loc2_++;
         }
         while(this.dataList.length > 0)
         {
            this.dataList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = HallOfFameDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.dataList.push(_loc5_);
            _loc2_++;
         }
         this.type = param1.readShort();
         this.pageSize = param1.readInt();
         this.pageSize = this.pageSize << 8 % 32 | this.pageSize >>> 32 - 8 % 32;
         this.currentPage = param1.readInt();
         this.currentPage = this.currentPage << 9 % 32 | this.currentPage >>> 32 - 9 % 32;
         this.totalPage = param1.readInt();
         this.totalPage = this.totalPage << 2 % 32 | this.totalPage >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HallOfFameDataCommand = null;
         var _loc3_:HallOfFameDataCommand = null;
         param1.writeShort(5955);
         param1.writeUTF(this.pageType);
         param1.writeByte(this.myList.length);
         for each(_loc2_ in this.myList)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.dataList.length);
         for each(_loc3_ in this.dataList)
         {
            _loc3_.write(param1);
         }
         param1.writeShort(this.type);
         param1.writeInt(this.pageSize >>> 8 % 32 | this.pageSize << 32 - 8 % 32);
         param1.writeInt(this.currentPage >>> 9 % 32 | this.currentPage << 32 - 9 % 32);
         param1.writeInt(this.totalPage >>> 2 % 32 | this.totalPage << 32 - 2 % 32);
      }
   }
}

