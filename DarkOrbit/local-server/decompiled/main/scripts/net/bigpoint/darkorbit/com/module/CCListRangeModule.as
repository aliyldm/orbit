package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCListRangeModule extends CCAbstractRangeModule
   {
      
      private static var _instance:CCListRangeModule;
      
      public var valueList:Vector.<CCValueModule>;
      
      public function CCListRangeModule(param1:Vector.<CCValueModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.valueList = new Vector.<CCValueModule>();
         }
         else
         {
            this.valueList = param1;
         }
      }
      
      public static function get instance() : CCListRangeModule
      {
         return _instance || (_instance = new CCListRangeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -22625;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         var _loc4_:CCValueModule = null;
         param1.readShort();
         super.read(param1);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.valueList.length > 0)
         {
            this.valueList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = CCValueModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.valueList.push(_loc4_);
            _loc2_++;
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         var _loc2_:CCValueModule = null;
         param1.writeShort(-22625);
         super.write(param1);
         param1.writeShort(this.valueList.length);
         for each(_loc2_ in this.valueList)
         {
            _loc2_.write(param1);
         }
      }
   }
}

