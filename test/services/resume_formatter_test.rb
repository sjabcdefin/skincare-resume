# frozen_string_literal: true

require 'test_helper'

class ResumeFormatterTest < ActiveSupport::TestCase
  test 'returns product_rows when records size does not exceed limit' do
    resume = skincare_resumes(:resume_with_user)
    display_resume = ResumeFormatter.new(resume:, mode: :display)
    print_resume = ResumeFormatter.new(resume:, mode: :print)

    records = [
      ResumeFormatter::DisplayRow.new(name: 'ニベアクリーム', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'コラージュリペアミルク', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'コラージュリペアローション', date: '2024/12/25', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'ゼオスキン ハイドレーティングクレンザー', date: '2025/12/25', over_limit: false)
    ]

    empty_records = Array.new(8) { ResumeFormatter::DisplayRow.new(name: "\u00A0", date: "\u00A0", over_limit: false) }

    assert_equal 12, display_resume.product_rows.size
    assert_equal records, display_resume.product_rows.first(4)
    assert_equal empty_records, display_resume.product_rows.last(8)

    assert_equal 12, print_resume.product_rows.size
    assert_equal records, print_resume.product_rows.first(4)
    assert_equal empty_records, print_resume.product_rows.last(8)
  end

  test 'returns medication_rows when records size does not exceed limit' do
    resume = skincare_resumes(:resume_with_user)
    display_resume = ResumeFormatter.new(resume:, mode: :display)
    print_resume = ResumeFormatter.new(resume:, mode: :print)

    records = [
      ResumeFormatter::DisplayRow.new(name: 'ヒルドイドローション', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'ビタミンD錠剤', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'ビタミンC錠剤', date: '2024/12/25', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'ベピオゲル', date: '2025/12/25', over_limit: false)
    ]

    assert_equal 4, display_resume.medication_rows.size
    assert_equal records, display_resume.medication_rows

    assert_equal 4, print_resume.medication_rows.size
    assert_equal records, print_resume.medication_rows
  end

  test 'returns allergy_rows when records size exceeds limit' do
    resume = skincare_resumes(:resume_over_limit)
    display_resume = ResumeFormatter.new(resume:, mode: :display)
    print_resume = ResumeFormatter.new(resume:, mode: :print)

    records = [
      ResumeFormatter::DisplayRow.new(name: '金属(ニッケル)', date: '－', over_limit: true),
      ResumeFormatter::DisplayRow.new(name: '金属(コバルト)', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: '花粉(イネ)', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: '花粉(ヨモギ)', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'ピーナッツ', date: '－', over_limit: false)
    ]

    assert_equal 5, display_resume.allergy_rows.size
    assert_equal records, display_resume.allergy_rows

    assert_equal 4, print_resume.allergy_rows.size
    assert_equal records.last(4), print_resume.allergy_rows
  end

  test 'returns treatment_rows when records size does not exceed limit' do
    resume = skincare_resumes(:resume_with_user)
    display_resume = ResumeFormatter.new(resume:, mode: :display)
    print_resume = ResumeFormatter.new(resume:, mode: :print)

    records = [
      ResumeFormatter::DisplayRow.new(name: 'ミラノリピール', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'ルメッカ', date: '－', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'エレクトロポーション ケアシス', date: '2024/12/25', over_limit: false),
      ResumeFormatter::DisplayRow.new(name: 'エレクトロポーション ケアシス', date: '2025/12/25', over_limit: false)
    ]

    empty_records = Array.new(20) { ResumeFormatter::DisplayRow.new(name: "\u00A0", date: "\u00A0", over_limit: false) }

    assert_equal 24, display_resume.treatment_rows.size
    assert_equal records, display_resume.treatment_rows.first(4)
    assert_equal empty_records, display_resume.treatment_rows.last(20)

    assert_equal 24, print_resume.treatment_rows.size
    assert_equal records, print_resume.treatment_rows.first(4)
    assert_equal empty_records, print_resume.treatment_rows.last(20)
  end

  test 'returns empty rows when resume is nil' do
    display_resume = ResumeFormatter.new(resume: nil, mode: :display)
    print_resume = ResumeFormatter.new(resume: nil, mode: :print)

    product_records = Array.new(12) { ResumeFormatter::DisplayRow.new(name: "\u00A0", date: "\u00A0", over_limit: false) }
    medication_records = Array.new(4) { ResumeFormatter::DisplayRow.new(name: "\u00A0", date: "\u00A0", over_limit: false) }
    allergy_records = Array.new(4) { ResumeFormatter::DisplayRow.new(name: "\u00A0", date: "\u00A0", over_limit: false) }
    treatment_records = Array.new(24) { ResumeFormatter::DisplayRow.new(name: "\u00A0", date: "\u00A0", over_limit: false) }

    assert_equal product_records, display_resume.product_rows
    assert_equal medication_records, display_resume.medication_rows
    assert_equal allergy_records, display_resume.allergy_rows
    assert_equal treatment_records, display_resume.treatment_rows

    assert_equal product_records, print_resume.product_rows
    assert_equal medication_records, print_resume.medication_rows
    assert_equal allergy_records, print_resume.allergy_rows
    assert_equal treatment_records, print_resume.treatment_rows
  end
end
