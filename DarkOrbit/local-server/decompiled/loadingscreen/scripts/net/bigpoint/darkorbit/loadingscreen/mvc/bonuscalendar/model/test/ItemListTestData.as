package net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.test
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.bonuscalendar.model.vo.ItemVO;
   
   public class ItemListTestData
   {
      
      public function ItemListTestData()
      {
         super();
      }
      
      public static function getItemList() : Vector.<ItemVO>
      {
         var _loc1_:Vector.<ItemVO> = new Vector.<ItemVO>();
         _loc1_.push(new ItemVO(1,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true));
         _loc1_.push(new ItemVO(2,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true,true));
         _loc1_.push(new ItemVO(3,"/do_img/global/items/booster/bb-01_100x100.png",15,true));
         _loc1_.push(new ItemVO(4,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true));
         _loc1_.push(new ItemVO(5,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true));
         _loc1_.push(new ItemVO(6,"/do_img/global/items/ship/mimesis/design/mimesis-red_100x100.png",14,true));
         _loc1_.push(new ItemVO(7,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true));
         _loc1_.push(new ItemVO(8,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true));
         _loc1_.push(new ItemVO(9,"/do_img/global/items/ship/c-elite-mmo_100x100.png",55,true));
         _loc1_.push(new ItemVO(10,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",55,true,true));
         _loc1_.push(new ItemVO(11,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27,false,true,true));
         _loc1_.push(new ItemVO(12,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(13,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(14,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(15,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(16,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(17,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(18,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(19,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(20,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(21,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(22,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(23,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",22));
         _loc1_.push(new ItemVO(24,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         _loc1_.push(new ItemVO(25,"/do_img/global/items/ship/pack-trinity-eic_100x100.png",27));
         return _loc1_;
      }
      
      public static function getItemListAsJSONString() : String
      {
         return "";
      }
   }
}

