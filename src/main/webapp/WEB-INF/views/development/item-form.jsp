<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>품목 등록</title>

    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined&family=Noto+Sans+KR:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/resources/css/common.css">

    <style>
        .form-panel {
            max-width: 960px;
        }

        .form-body {
            padding: 22px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .form-field {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-field.full-width {
            grid-column: 1 / -1;
        }

        .form-field label {
            color: var(--text);
            font-size: 13px;
            font-weight: 700;
        }

        .required {
            margin-left: 3px;
            color: #d42424;
        }

        .form-field input {
            width: 100%;
            height: 42px;
            padding: 0 12px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            outline: none;
            transition: 150ms ease;
        }

        .form-field input:hover {
            border-color: #aab6c5;
        }

        .form-field input:focus {
            border-color: var(--blue);
            box-shadow: 0 0 0 3px rgba(18, 103, 214, 0.12);
        }

        .field-help {
            margin: 0;
            color: var(--muted);
            font-size: 11px;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
            padding-top: 18px;
            border-top: 1px solid var(--border);
        }

        .secondary-button {
            display: inline-flex;
            height: 40px;
            align-items: center;
            justify-content: center;
            gap: 7px;
            padding: 0 16px;
            color: var(--text);
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 5px;
            font-weight: 700;
            cursor: pointer;
        }

        .secondary-button:hover {
            color: var(--blue);
            border-color: var(--blue);
            background: #f8fbff;
        }

        @media (max-width: 760px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-field.full-width {
                grid-column: auto;
            }

            .form-actions {
                flex-direction: column-reverse;
            }

            .form-actions > * {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

<div class="app-shell">

    <jsp:include page="/WEB-INF/views/common/header.jsp" />

    <main class="workspace">

        <section class="page-heading">
            <div>
                <p class="eyebrow">DEVELOPMENT</p>
                <h1>품목 등록</h1>
                <p>생산과 BOM에서 사용할 새로운 품목 정보를 등록합니다.</p>
            </div>
        </section>

        <section class="panel form-panel">

            <div class="panel-header">
                <div>
                    <p class="eyebrow">NEW ITEM</p>
                    <h2>기본 정보 입력</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/development/items"
                  method="post">

                <div class="form-body">

                    <div class="notice">
                        <span class="material-symbols-outlined">
                            info
                        </span>
                        <p>
                            품목코드는 등록 후 변경할 수 없습니다.
                            필수 항목을 정확히 입력해 주세요.
                        </p>
                    </div>

                    <div class="form-grid">

                        <div class="form-field">
                            <label for="itemCode">
                                품목코드
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   id="itemCode"
                                   name="itemCode"
                                   maxlength="30"
                                   placeholder="예: ITEM001"
                                   required>

                            <p class="field-help">
                                최대 30자까지 입력할 수 있습니다.
                            </p>
                        </div>

                        <div class="form-field">
                            <label for="itemName">
                                품목명
                                <span class="required">*</span>
                            </label>

                            <input type="text"
                                   id="itemName"
                                   name="itemName"
                                   maxlength="100"
                                   placeholder="품목명을 입력하세요"
                                   required>
                        </div>

                        <div class="form-field">
                            <label for="spec">규격</label>

                            <input type="text"
                                   id="spec"
                                   name="spec"
                                   maxlength="200"
                                   placeholder="예: 200 × 200">
                        </div>

                        <div class="form-field">
                            <label for="material">재질</label>

                            <input type="text"
                                   id="material"
                                   name="material"
                                   maxlength="100"
                                   placeholder="예: 알루미늄">
                        </div>

                        <div class="form-field full-width">
                            <label for="makeSpec">제작 사양</label>

                            <input type="text"
                                   id="makeSpec"
                                   name="makeSpec"
                                   maxlength="200"
                                   placeholder="제작 사양을 입력하세요">
                        </div>

                        <div class="form-field full-width">
                            <label for="drawingRef">도면 참조</label>

                            <input type="text"
                                   id="drawingRef"
                                   name="drawingRef"
                                   maxlength="200"
                                   placeholder="예: DWG-001">
                        </div>

                    </div>

                    <div class="form-actions">

                        <a class="secondary-button"
                           href="${pageContext.request.contextPath}/development/items">
                            취소
                        </a>

                        <button class="primary-button" type="submit">
                            <span class="material-symbols-outlined">
                                save
                            </span>
                            품목 등록
                        </button>

                    </div>

                </div>
            </form>

        </section>

    </main>
</div>

<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>

</body>
</html>